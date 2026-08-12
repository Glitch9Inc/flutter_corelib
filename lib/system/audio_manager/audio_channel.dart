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
  static const int _defaultMaxPlayers = 8;

  final String name;
  final bool defaultLoop;
  final bool fadeAudioOnStop;
  final int fadeOutDurationInMillis;
  final bool allowAudioOverlap;
  final bool ignoreSameAudio;

  /// Upper bound on players kept alive when [allowAudioOverlap] is enabled.
  /// Once reached the oldest player is reclaimed, so a player that gets wedged
  /// (never reports completion) can never starve the channel for good.
  final int maxPlayers;

  final TAudioPlayer Function() playerBuilder;
  final Logger _logger;

  /// Created on first access, not in [init]: the volume has to be readable
  /// before (or without) initialization — the settings UI and the lobby BGM
  /// controller both read it while init is still in flight. Prefs.create is
  /// synchronous, cached, and falls back to the default on failure.
  late final Prefs<double> _volume =
      Prefs.create<double>('${name}_volume', _defaultVolume);

  final List<TAudioPlayer> _players = <TAudioPlayer>[];

  /// Players handed out by [_fetchPlayer] and not done with [play] yet. The
  /// reservation is taken synchronously so two overlapping play() calls never
  /// drive the same player.
  final Set<TAudioPlayer> _busyPlayers = <TAudioPlayer>{};

  /// Players that reported completion while still reserved; they are recycled
  /// once their play() call returns instead of during its setup.
  final Set<TAudioPlayer> _completedWhileBusy = <TAudioPlayer>{};

  /// Recycled players waiting to be reused. They hold no playback, so
  /// [pause]/[resume] must leave them alone — unlike a paused player.
  final Set<TAudioPlayer> _idlePlayers = <TAudioPlayer>{};

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
    this.maxPlayers = _defaultMaxPlayers,
  }) : _logger = Logger(name) {
    if (fadeOutDurationInMillis < 0) {
      throw ArgumentError.value(
        fadeOutDurationInMillis,
        'fadeOutDurationInMillis',
        'Must not be negative',
      );
    }
    if (maxPlayers < 1) {
      throw ArgumentError.value(maxPlayers, 'maxPlayers', 'Must be at least 1');
    }
  }

  bool get playing => _players.any((player) => player.playing);

  Future<void> init() async {
    _isDisposed = false;
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

  Future<void> pause() => Future.wait(_activePlayers.map((p) => p.pause()));

  Future<void> resume() => Future.wait(_activePlayers.map((p) => p.resume()));

  Iterable<TAudioPlayer> get _activePlayers =>
      _players.where((player) => !_idlePlayers.contains(player));

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
      _busyPlayers.remove(player);
      if (!shouldLoop && player is! AudioChannelCompletion && !player.playing) {
        await _disposePlayer(player);
      } else if (_completedWhileBusy.remove(player)) {
        await _recyclePlayer(player);
      }
    } on Object catch (error, stackTrace) {
      _logger.severe(
        'Audio playback failed for "$filePath"',
        error,
        stackTrace,
      );
      await _disposePlayer(player);
      rethrow;
    } finally {
      // A player that stays reserved would be skipped by every later fetch;
      // one that stays in the pool while broken would swallow every later play.
      _busyPlayers.remove(player);
      _completedWhileBusy.remove(player);
    }
  }

  Future<TAudioPlayer> _fetchPlayer() async {
    if (!allowAudioOverlap) {
      _fadeGeneration++;
      await Future.wait(List<TAudioPlayer>.of(_players).map(_disposePlayer));
      return _createPlayer();
    }

    for (final player in _players) {
      if (_busyPlayers.contains(player) || player.playing) continue;
      // Reserve synchronously: overlapping play() calls that share a player
      // abort each other's load and can leave it stuck and silent.
      _busyPlayers.add(player);
      _completedWhileBusy.remove(player);
      _idlePlayers.remove(player);
      return player;
    }

    if (_players.length >= maxPlayers) {
      await _disposePlayer(_players.first);
    }
    return _createPlayer();
  }

  Future<TAudioPlayer> _createPlayer() async {
    final player = playerBuilder();
    try {
      await player.setVolume(getVolume());
    } on Object {
      // A half-initialized player must never enter the pool: it would be handed
      // to every later play() call and silently drop every sound.
      try {
        await player.dispose();
      } on Object catch (error, stackTrace) {
        _logger.warning('Failed to dispose a broken player', error, stackTrace);
      }
      rethrow;
    }

    _players.add(player);
    _busyPlayers.add(player);

    if (player is AudioChannelCompletion) {
      final completionPlayer = player as AudioChannelCompletion;
      _completionSubscriptions[player] =
          completionPlayer.onCompleted.listen((_) {
        // Completion can land while the player is being set up for its next
        // sound; stopping it there would cut off the playback that is starting.
        if (_busyPlayers.contains(player)) {
          _completedWhileBusy.add(player);
          return;
        }
        unawaited(_recyclePlayer(player));
      });
    }
    return player;
  }

  /// Returns a finished player to the pool instead of tearing it down, so the
  /// channel does not build and drop a native player for every sound effect.
  Future<void> _recyclePlayer(TAudioPlayer player) async {
    if (!_players.contains(player)) return;
    try {
      await player.stop();
      if (_players.contains(player)) _idlePlayers.add(player);
    } on Object catch (error, stackTrace) {
      _logger.warning('Failed to recycle player', error, stackTrace);
      await _disposePlayer(player);
    }
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
    _busyPlayers.remove(player);
    _completedWhileBusy.remove(player);
    _idlePlayers.remove(player);
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
