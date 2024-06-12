import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_corelib/flutter_corelib.dart';

const String _rootPath = 'assets/sounds/';
const String _defaultExtension = '.mp3';
const double _defaultVolume = 1;

const String _subfolderBgm = 'bgm/';
const String _subfolderSfx = 'sfx/';
const String _subfolderVoice = 'voice/';

enum SoundType {
  bgm,
  sfx,
  voice,
}

class SoundManager {
  static SoundManager? _instance; // nullable 타입으로 선언
  static SoundManager get instance {
    _instance ??= SoundManager._(); // _instance가 null일 경우에만 새 인스턴스 생성
    return _instance!;
  }

  SoundManager._();

  final sfxPlayer = AssetsAudioPlayer();
  final bgmPlayer = AssetsAudioPlayer();
  final voicePlayer = AssetsAudioPlayer();

  late Prefs<double> _bgmVolume;
  late Prefs<double> _sfxVolume;
  late Prefs<double> _voiceVolume;

  Future<void> init() async {
    _bgmVolume = await Prefs.create<double>('bgmVolume');
    _sfxVolume = await Prefs.create<double>('sfxVolume');
    _voiceVolume = await Prefs.create<double>('voiceVolume');

    setVolume(SoundType.bgm, _bgmVolume.value ?? _defaultVolume);
    setVolume(SoundType.sfx, _sfxVolume.value ?? _defaultVolume);
    setVolume(SoundType.voice, _voiceVolume.value ?? _defaultVolume);
  }

  AssetsAudioPlayer getPlayer(SoundType type) {
    switch (type) {
      case SoundType.bgm:
        return bgmPlayer;
      case SoundType.sfx:
        return sfxPlayer;
      case SoundType.voice:
        return voicePlayer;
    }
  }

  Prefs<double> getVolumePrefs(SoundType type) {
    switch (type) {
      case SoundType.bgm:
        return _bgmVolume;
      case SoundType.sfx:
        return _sfxVolume;
      case SoundType.voice:
        return _voiceVolume;
    }
  }

  String getSubfolder(SoundType type) {
    switch (type) {
      case SoundType.bgm:
        return _subfolderBgm;
      case SoundType.sfx:
        return _subfolderSfx;
      case SoundType.voice:
        return _subfolderVoice;
    }
  }

  /// 배경음 볼륨을 설정합니다.
  /// 볼륨은 0.0 ~ 1.0 사이의 값으로 설정합니다.
  /// 볼륨이 0.0이면 소리가 나지 않습니다.
  /// 볼륨이 1.0이면 최대 볼륨으로 소리가 나옵니다.
  void setVolume(SoundType type, double volume) {
    getVolumePrefs(type).value = volume;
    getPlayer(type).setVolume(volume);
  }

  /// 사운드 파일명(확장자 포함)을 인자로 받아 사운드를 재생합니다.
  void play(SoundType type, String sound) {
    // 실제 사운드 재생 로직 구현
    Debug.log('SoundManager.play: $sound ($type)');

    // 확장자가 있는지 확인
    if (!sound.contains('.')) sound += _defaultExtension;
    String subfolder = getSubfolder(type);
    bool loop = type == SoundType.bgm;

    getPlayer(type).open(
      Audio("$_rootPath$subfolder$sound"),
      autoStart: true,
      showNotification: false,
      loopMode: loop ? LoopMode.single : LoopMode.none,
    );
  }

  void playBgm(String sound) => play(SoundType.bgm, sound);
  void playSfx(String sound) => play(SoundType.sfx, sound);
  void playVoice(String sound) => play(SoundType.voice, sound);

  void dispose() {
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    voicePlayer.dispose();
  }
}
