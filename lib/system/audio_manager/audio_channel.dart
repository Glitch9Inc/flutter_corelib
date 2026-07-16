import 'dart:async';

import 'package:flutter_corelib/flutter_corelib.dart';

mixin AudioChannelPlayer {
  Future setAsset(String assetPath);
  Future setUrl(String url);
  Future setFilePath(String filePath);
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

class AudioChannel<TAudioPlayer extends AudioChannelPlayer> {
  static const double _defaultVolume = 1;
  static const int _defaultMinFadeOutDurationInMillis = 2000;

  // Properties
  final String name;
  final bool defaultLoop;
  final bool fadeAudioOnStop;
  final int fadeOutDurationInMillis;

  // Components
  final Logger _logger;
  final bool allowAudioOverlap;
  final bool ignoreSameAudio;

  // Saved values
  late Prefs<double> _volume;

  // Cache values
  FileSource? _lastFileLocation;
  FileSource? _currentFileSource;
  String? _lastFilePath;
  String? _currentFilePath;
  bool? _lastLoop;
  bool? _currentLoop;

  bool _isFadingOut = false;
  Timer? _fadeOutTimer;

  final TAudioPlayer Function() playerBuilder;
  final List<TAudioPlayer> _players = [];

  bool get playing => _players.any((player) => player.playing);

  AudioChannel(
    this.name, {
    required this.defaultLoop,
    required this.playerBuilder,
    this.fadeAudioOnStop = false,
    this.fadeOutDurationInMillis = _defaultMinFadeOutDurationInMillis,
    this.allowAudioOverlap = true,
    this.ignoreSameAudio = false,
  }) : _logger = Logger(name);

  Future<void> init() async {
    _volume = Prefs.create<double>('${name}_volume', _defaultVolume);
    await setVolume(_volume.value);
  }

  Future<void> setVolume(double volume) async {
    _volume.setValue(volume);
    for (var player in _players) {
      await player.setVolume(volume);
    }
  }

  double getVolume() => _volume.value;

  Future<void> playLastAudio() async {
    if (_lastFileLocation == null || _lastFilePath == null) {
      _logger.severe('No last audio to play');
      return;
    }

    await play(_lastFileLocation!, _lastFilePath!, loop: _lastLoop);
  }

  Future<void> pause() async {
    for (var player in _players) {
      await player.pause();
    }
  }

  Future<void> resume() async {
    for (var player in _players) {
      await player.play();
    }
  }

  Future<void> stop() async {
    if (fadeAudioOnStop) {
      for (var player in _players) {
        await fadeOutAudio(player);
      }
    } else {
      await _disposePlayers();
    }
  }

  Future<void> _disposePlayers() async {
    for (var player in _players) {
      await player.stop();
      await player.dispose();
    }
    _players.clear();
  }

  Future<void> toggle() async {
    if (playing) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> dispose() async {
    await _disposePlayers();
    _fadeOutTimer?.cancel();
    _fadeOutTimer = null;
  }

  Future<TAudioPlayer> _createPlayer() async {
    TAudioPlayer player = playerBuilder();
    _players.add(player);
    await player.setVolume(getVolume());
    return player;
  }

  Future<TAudioPlayer> _fetchPlayer() async {
    if (playing && !allowAudioOverlap) {
      if (_isFadingOut) _interruptFadeOut();
      await _disposePlayers();
      return await _createPlayer();
    }

    if (_players.isEmpty) {
      return await _createPlayer();
    } else {
      return _players.first;
    }
  }

  Future<void> play(FileSource fileSource, String filePath, {bool? loop}) async {
    if (filePath.isEmpty) {
      _logger.severe('Empty file path');
      return;
    }

    final splitFilePath = filePath.split('.').first;
    if (splitFilePath.isEmpty) {
      _logger.severe('Empty file path');
      return;
    }

    final isSameFilePlaying = _currentFileSource == fileSource && _currentFilePath == filePath;

    if (playing && ignoreSameAudio && isSameFilePlaying) {
      _logger.info('The same audio is already playing: $filePath');
      return;
    }

    if (!isSameFilePlaying) {
      _lastFileLocation = _currentFileSource;
      _lastFilePath = _currentFilePath;
      _lastLoop = _currentLoop;

      _currentFileSource = fileSource;
      _currentFilePath = filePath;
      _currentLoop = loop;
    }

    _logger.info('Playing audio: $filePath');
    final player = await _fetchPlayer();

    try {
      switch (fileSource) {
        case FileSource.assetsDir:
          await player.setAsset(filePath);
          break;
        case FileSource.http:
          await player.setUrl(filePath);
          break;
        default:
          await player.setFilePath(filePath);
          break;
      }
    } catch (e) {
      _logger.severe('Error setting audio file ($filePath) on player: $e');
      return;
    }

    await player.setLoop(loop ?? defaultLoop);
    await player.play();
  }

  Future<void> fadeOutAudio(TAudioPlayer player) async {
    if (_fadeOutTimer != null) {
      _fadeOutTimer!.cancel();
    }

    _isFadingOut = true;
    const step = Duration(milliseconds: 50);
    final int numberOfSteps = (fadeOutDurationInMillis / step.inMilliseconds).floor();
    final double volumeDecrease = getVolume() / numberOfSteps;

    _fadeOutTimer = Timer.periodic(step, (timer) {
      double newVolume = player.volume - volumeDecrease;
      if (newVolume <= 0) {
        newVolume = 0;
        timer.cancel();
        _fadeOutTimer = null;
        _isFadingOut = false;

        player.stop().then((_) {
          player.setVolume(getVolume());
        }).catchError((e) {
          _logger.severe('Error stopping audio during fade-out: $e');
        });
      }

      player.setVolume(newVolume);
    });
  }

  void _interruptFadeOut() {
    _fadeOutTimer?.cancel();
    _fadeOutTimer = null;
    _isFadingOut = false;
  }
}
