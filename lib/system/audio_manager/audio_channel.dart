import 'dart:async';

import 'package:logging/logging.dart';

import '../../prefs/prefs.dart';
import '../io/file_path.dart';

mixin AudioChannelPlayer {
  Future<void> setAsset(String assetPath);
  Future<void> setUrl(String url);
  Future<void> setFilePath(String filePath);
  Future<void> setLoop(bool loop);
  Future<void> setVolume(double volume);
  Future<void> play();
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Future<void> seek(Duration position);
  Future<void> dispose();

  bool get playing;
  double get volume;
}

/// Optional player capability used to release overlap players on completion.
abstract interface class AudioChannelCompletion {
  Stream<void> get onCompleted;
}

class AudioChannel<TAudioPlayer extends AudioChannelPlayer> {
  static const double _defaultVolume = 1;
  static const int _defaultFadeOutDurationInMillis = 2000;

  final String name;
  final bool defaultLoop;
  final bool fadeAudioOnStop;
  final int fadeOutDurationInMillis;
  final bool allowAudioOverlap;
  final bool ignoreSameAudio;
  final TAudioPlayer Function() playerBuilder;
  final Logger _logger;

  late Prefs<double> _volume;
  final List<TAudioPlayer> _players = <TAudioPlayer>[];
  final Map<TAudioPlayer, StreamSubscription<void>> _completionSubscriptions =
      <TAudioPlayer, StreamSubscription<void>>{};

  FileSource? _lastFileLocation;
  FileSource? _currentFileSource;
  String? _lastFilePath;
  String? _currentFilePath;
  bool? _lastLoop;
  bool? _currentLoop;
  int _fadeGeneration = 0;
  bool _isDisposed = false;

  AudioChannel(
    this.name, {
    required this.defaultLoop,
    required this.playerBuilder,
    this.fadeAudioOnStop = false,
    this.fadeOutDurationInMillis = _defaultFadeOutDurationInMillis,
    this.allowAudioOverlap = true,
    this.ignoreSameAudio = false,
  }) : _logger = Logger(name) {
    if (fadeOutDurationInMillis < 0) {
      throw ArgumentError.value(
        fadeOutDurationInMillis,
        'fadeOutDurationInMillis',
        'Must not be negative',
      );
    }
  }

  bool get playing => _players.any((player) => player.playing);

  Future<void> init() async {
    _isDisposed = false;
    _volume = Prefs.create<double>('${name}_volume', _defaultVolume);
    await setVolume(_volume.value);
  }

  Future<void> setVolume(double volume) async {
    _ensureActive();
    final clamped = volume.clamp(0.0, 1.0).toDouble();
    await _volume.setValue(clamped);
    await Future.wait(
      _players.map((player) => player.setVolume(clamped)),
    );
  }

  double getVolume() => _volume.value;

  Future<void> playLastAudio() async {
    final source = _lastFileLocation;
    final path = _lastFilePath;
    if (source == null || path == null) {
      throw StateError('No last audio to play');
    }
    await play(source, path, loop: _lastLoop);
  }

  Future<void> pause() => Future.wait(_players.map((player) => player.pause()));

  Future<void> resume() =>
      Future.wait(_players.map((player) => player.resume()));

  Future<void> stop() async {
    _fadeGeneration++;
    final players = List<TAudioPlayer>.of(_players);
    if (fadeAudioOnStop && fadeOutDurationInMillis > 0) {
      final generation = _fadeGeneration;
      await Future.wait(
        players.map((player) => _fadeOut(player, generation)),
      );
    } else {
      await Future.wait(players.map(_disposePlayer));
    }
  }

  Future<void> toggle() => playing ? pause() : resume();

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _fadeGeneration++;
    await Future.wait(List<TAudioPlayer>.of(_players).map(_disposePlayer));
  }

  Future<void> play(
    FileSource fileSource,
    String filePath, {
    bool? loop,
  }) async {
    _ensureActive();
    if (filePath.trim().isEmpty) {
      throw ArgumentError.value(filePath, 'filePath', 'Must not be empty');
    }

    final isSameFilePlaying =
        _currentFileSource == fileSource && _currentFilePath == filePath;
    if (playing && ignoreSameAudio && isSameFilePlaying) return;

    if (!isSameFilePlaying) {
      _lastFileLocation = _currentFileSource;
      _lastFilePath = _currentFilePath;
      _lastLoop = _currentLoop;
      _currentFileSource = fileSource;
      _currentFilePath = filePath;
      _currentLoop = loop;
    }

    final player = await _fetchPlayer();
    try {
      switch (fileSource) {
        case FileSource.assetsDir:
          await player.setAsset(filePath);
        case FileSource.http:
          await player.setUrl(filePath);
        case FileSource.tempDir:
        case FileSource.appDir:
        case FileSource.localDrive:
          await player.setFilePath(filePath);
      }
      final shouldLoop = loop ?? defaultLoop;
      await player.setLoop(shouldLoop);
      await player.play();
      if (!shouldLoop && !player.playing) {
        await _disposePlayer(player);
      }
    } on Object catch (error, stackTrace) {
      _logger.severe(
        'Audio playback failed for "$filePath"',
        error,
        stackTrace,
      );
      await _disposePlayer(player);
      rethrow;
    }
  }

  Future<TAudioPlayer> _fetchPlayer() async {
    if (!allowAudioOverlap) {
      _fadeGeneration++;
      await Future.wait(List<TAudioPlayer>.of(_players).map(_disposePlayer));
      return _createPlayer();
    }

    for (final player in _players) {
      if (!player.playing) return player;
    }
    return _createPlayer();
  }

  Future<TAudioPlayer> _createPlayer() async {
    final player = playerBuilder();
    _players.add(player);
    await player.setVolume(getVolume());

    if (player is AudioChannelCompletion) {
      final completionPlayer = player as AudioChannelCompletion;
      _completionSubscriptions[player] =
          completionPlayer.onCompleted.listen((_) {
        unawaited(_disposePlayer(player));
      });
    }
    return player;
  }

  Future<void> _fadeOut(TAudioPlayer player, int generation) async {
    const stepDuration = Duration(milliseconds: 50);
    final steps =
        (fadeOutDurationInMillis / stepDuration.inMilliseconds).ceil().clamp(
              1,
              1000000,
            );
    final startVolume = player.volume.clamp(0.0, 1.0);

    for (var step = 1; step <= steps; step++) {
      if (_isDisposed || generation != _fadeGeneration) return;
      final nextVolume = startVolume * (1 - step / steps);
      await player.setVolume(nextVolume.clamp(0.0, 1.0));
      if (step < steps) await Future<void>.delayed(stepDuration);
    }
    await _disposePlayer(player);
  }

  Future<void> _disposePlayer(TAudioPlayer player) async {
    if (!_players.remove(player)) return;
    final subscription = _completionSubscriptions.remove(player);
    await subscription?.cancel();
    try {
      await player.stop();
    } finally {
      await player.dispose();
    }
  }

  void _ensureActive() {
    if (_isDisposed) throw StateError('AudioChannel "$name" is disposed');
  }
}
