// import 'dart:async';

// import 'package:flutter_corelib/flutter_corelib.dart';

// class JustAudioPlayer {
//   static const double _defaultVolume = 1;
//   static const int _defaultMinFadeOutDurationInMillis = 2000;

//   // Properties
//   final String name;
//   final bool defaultLoop;
//   final bool fadeOutOnStop;
//   final int fadeOutDurationInMillis;

//   // Components
//   final Logger _logger;
//   final bool _allowMultipleAudios;
//   final bool _ignoreSameAudio;

//   // Saved values
//   late Prefs<double> _volume;

//   // Cache values
//   FileSource? _lastFileLocation;
//   FileSource? _currentFileSource;
//   String? _lastFilePath;
//   String? _currentFilePath;
//   bool? _lastLoop;
//   bool? _currentLoop;

//   bool _isFadingOut = false;
//   Timer? _fadeOutTimer;

//   final _mainPlayer = AudioPlayer();
//   final List<AudioPlayer> _backupPlayers = [];

//   bool isInit = false;

//   JustAudioPlayer(
//     this.name, {
//     required this.defaultLoop,
//     this.fadeOutOnStop = false,
//     this.fadeOutDurationInMillis = _defaultMinFadeOutDurationInMillis,
//     bool? allowMultipleAudios,
//     bool? ignoreSameAudio,
//   })  : _logger = Logger(name),
//         _allowMultipleAudios = allowMultipleAudios ?? false,
//         _ignoreSameAudio = ignoreSameAudio ?? false {
//     init();
//   }

//   Future<void> init() async {
//     _volume = await Prefs.create<double>('${name}_volume');
//     setVolume(_volume.value ?? 1);
//     isInit = true;
//   }

//   void setVolume(double volume) {
//     _volume.setValue(volume); // = volume;
//     _mainPlayer.setVolume(volume); // 누락된 볼륨 설정 추가
//     for (var player in _backupPlayers) {
//       player.setVolume(volume);
//     }
//   }

//   bool get playing => _mainPlayer.playing || _backupPlayers.any((player) => player.playing);

//   double getVolume() => _volume.value ?? _defaultVolume;

//   Future<void> playLastAudio() async {
//     if (_lastFileLocation == null || _lastFilePath == null) {
//       _logger.severe('No last audio to play');
//       return;
//     }

//     await play(_lastFileLocation!, _lastFilePath!, loop: _lastLoop);
//   }

//   Future<void> pause() async {
//     await _mainPlayer.pause();
//     for (var player in _backupPlayers) {
//       await player.pause();
//     }
//   }

//   Future<void> resume() async {
//     await _mainPlayer.play();
//     for (var player in _backupPlayers) {
//       await player.play();
//     }
//   }

//   Future<void> stop() async {
//     if (fadeOutOnStop) {
//       await fadeOutAudio();
//     } else {
//       await _stopAllPlayers();
//     }
//   }

//   Future<void> _stopAllPlayers() async {
//     await _mainPlayer.stop();

//     for (var player in _backupPlayers) {
//       await player.stop();
//       await player.dispose();
//     }
//     _backupPlayers.clear();
//   }

//   Future<void> toggle() async {
//     if (playing) {
//       await pause();
//     } else {
//       await resume();
//     }
//   }

//   void dispose() {
//     _stopAllPlayers();
//     _fadeOutTimer?.cancel();
//     _fadeOutTimer = null;
//   }

//   Future<AudioPlayer> _getPlayer() async {
//     if (!_mainPlayer.playing) {
//       return _mainPlayer;
//     }

//     if (!_allowMultipleAudios) {
//       if (_isFadingOut) {
//         _interruptFadeOut();
//       }
//       await _mainPlayer.stop();
//       return _mainPlayer;
//     }

//     final AudioPlayer player = AudioPlayer();
//     player.setVolume(getVolume()); // Ensure volume is set for new players
//     _backupPlayers.add(player);
//     return player;
//   }

//   Future<void> play(FileSource fileSource, String filePath, {bool? loop}) async {
//     if (filePath.isEmpty) {
//       _logger.severe('Empty file path');
//       return;
//     }

//     final splitFilePath = filePath.split('.').first;
//     if (splitFilePath.isEmpty) {
//       _logger.severe('Empty file path');
//       return;
//     }

//     final isSameFilePlaying = _currentFileSource == fileSource && _currentFilePath == filePath;

//     if (_mainPlayer.playing && _ignoreSameAudio && isSameFilePlaying) {
//       _logger.info('The same audio is already playing: $filePath');
//       return;
//     }

//     if (!isSameFilePlaying) {
//       _lastFileLocation = _currentFileSource;
//       _lastFilePath = _currentFilePath;
//       _lastLoop = _currentLoop;

//       _currentFileSource = fileSource;
//       _currentFilePath = filePath;
//       _currentLoop = loop;
//     }

//     _logger.info('Playing audio: $filePath');

//     final AudioPlayer player = await _getPlayer();

//     try {
//       switch (fileSource) {
//         case FileSource.assetsDir:
//           await player.setAsset(filePath);
//           break;
//         case FileSource.http:
//           await player.setUrl(filePath);
//           break;
//         default:
//           await player.setFilePath(filePath);
//           break;
//       }
//     } catch (e) {
//       _logger.severe('Error setting audio file ($filePath) on player: $e');
//       return;
//     }

//     final isNotMainPlayer = player != _mainPlayer;

//     final newLoop = loop ?? defaultLoop;
//     if (isNotMainPlayer || newLoop != _currentLoop) {
//       await player.setLoopMode(newLoop ? LoopMode.one : LoopMode.off);
//     }

//     await player.play();

//     if (isNotMainPlayer) {
//       player.playerStateStream.listen((state) async {
//         if (state.processingState == ProcessingState.completed || state.processingState == ProcessingState.idle) {
//           //await player.stop(); // Stop before disposing
//           await player.dispose();
//           _backupPlayers.remove(player); // Make sure to remove from the list after disposal
//         }
//       });
//     }
//   }

//   Future<void> fadeOutAudio() async {
//     if (_fadeOutTimer != null) {
//       _fadeOutTimer!.cancel();
//     }

//     _isFadingOut = true;
//     const step = Duration(milliseconds: 50);
//     final int numberOfSteps = fadeOutDurationInMillis ~/ step.inMilliseconds;
//     final double volumeDecrease = getVolume() / numberOfSteps;

//     _fadeOutTimer = Timer.periodic(step, (timer) {
//       double newVolume = _mainPlayer.volume - volumeDecrease;
//       if (newVolume <= 0) {
//         _mainPlayer.setVolume(0);
//         timer.cancel();
//         _fadeOutTimer = null;
//         _isFadingOut = false;

//         // Stop and reset volume after timer completes
//         _mainPlayer.stop().then((_) {
//           _mainPlayer.setVolume(getVolume());
//         }).catchError((e) {
//           _logger.severe('Error stopping audio during fade-out: $e');
//         });
//       } else {
//         _mainPlayer.setVolume(newVolume);
//       }
//     });
//   }

//   void _interruptFadeOut() {
//     _fadeOutTimer?.cancel();
//     _fadeOutTimer = null;
//     _isFadingOut = false;
//     _mainPlayer.setVolume(getVolume());
//   }
// }
