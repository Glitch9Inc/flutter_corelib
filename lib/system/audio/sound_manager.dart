import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:just_audio/just_audio.dart';

const String _defaultExtension = '.mp3';
const double _defaultVolume = 1;

enum AudioType {
  bgm,
  sfx,
  voice,
}

enum FileLocation {
  assets,
  file,
  network,
}

class SoundManager {
  SoundManager._internal();
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  static AudioPlayer get bgm => _instance.bgmPlayer;
  static AudioPlayer get sfx => _instance.sfxPlayer;
  static AudioPlayer get voice => _instance.voicePlayer;

  final sfxPlayer = AudioPlayer();
  final bgmPlayer = AudioPlayer();
  final voicePlayer = AudioPlayer();
  final Logger _logger = Logger('SoundManager');

  late Prefs<double> _bgmVolume;
  late Prefs<double> _sfxVolume;
  late Prefs<double> _voiceVolume;

  static Future<void> init() async {
    _instance._bgmVolume = await Prefs.create<double>('bgmVolume');
    _instance._sfxVolume = await Prefs.create<double>('sfxVolume');
    _instance._voiceVolume = await Prefs.create<double>('voiceVolume');

    setVolume(AudioType.bgm, _instance._bgmVolume.value ?? _defaultVolume);
    setVolume(AudioType.sfx, _instance._sfxVolume.value ?? _defaultVolume);
    setVolume(AudioType.voice, _instance._voiceVolume.value ?? _defaultVolume);
  }

  AudioPlayer getPlayer(AudioType type) {
    switch (type) {
      case AudioType.bgm:
        return bgmPlayer;
      case AudioType.sfx:
        return sfxPlayer;
      case AudioType.voice:
        return voicePlayer;
    }
  }

  Prefs<double> getVolumePrefs(AudioType type) {
    switch (type) {
      case AudioType.bgm:
        return _bgmVolume;
      case AudioType.sfx:
        return _sfxVolume;
      case AudioType.voice:
        return _voiceVolume;
    }
  }

  /// 배경음 볼륨을 설정합니다.
  /// 볼륨은 0.0 ~ 1.0 사이의 값으로 설정합니다.
  /// 볼륨이 0.0이면 소리가 나지 않습니다.
  /// 볼륨이 1.0이면 최대 볼륨으로 소리가 나옵니다.
  static void setVolume(AudioType type, double volume) {
    _instance.getVolumePrefs(type).value = volume;
    _instance.getPlayer(type).setVolume(volume);
  }

  /// 배경음 볼륨을 가져옵니다.
  static double getVolume(AudioType type) {
    return _instance.getVolumePrefs(type).value ?? _defaultVolume;
  }

  /// 사운드 파일명(확장자 포함)을 인자로 받아 사운드를 재생합니다.
  static void play(AudioType type, String sound) async {
    _instance._logger.info('SoundManager.play: $sound ($type)');

    if (!sound.contains('.')) sound += _defaultExtension;
    bool loop = type == AudioType.bgm;

    try {
      await _instance.getPlayer(type).setAsset("$sound");
      _instance.getPlayer(type).setLoopMode(loop ? LoopMode.one : LoopMode.off);
      _instance.getPlayer(type).play();
    } catch (e) {
      _instance._logger.severe('Error playing sound: $e');
    }
  }

  static void playBgm(String sound) => play(AudioType.bgm, sound);
  static void playSfx(String sound) => play(AudioType.sfx, sound);
  static void playVoice(String sound) => play(AudioType.voice, sound);

  void dispose() {
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    voicePlayer.dispose();
  }
}
