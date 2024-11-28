import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter_game_framework/flutter_game_framework.dart';
import 'package:flutter_corelib/core/audio/extended_audio_player.dart';

const String _defaultExtension = '.mp3';

class AudioManager extends GetxController {
  AudioManager._internal();
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final Logger _logger = Logger('AudioManager');

  static ExtendedAudioPlayer get bgm => _instance.bgmPlayer;
  static ExtendedAudioPlayer get sfx => _instance.sfxPlayer;
  static ExtendedAudioPlayer get voice => _instance.voicePlayer;

  final sfxPlayer = ExtendedAudioPlayer('SFX', defaultLoop: false, allowMultipleAudios: true);
  final bgmPlayer = ExtendedAudioPlayer('BGM', defaultLoop: true, fadeOutOnStop: true, ignoreSameAudio: true);
  final voicePlayer = ExtendedAudioPlayer('VOICE', defaultLoop: false, allowMultipleAudios: true);

  static ExtendedAudioPlayer getAudioPlayer(AudioType type) {
    switch (type) {
      case AudioType.bgm:
        return _instance.bgmPlayer;
      case AudioType.sfx:
        return _instance.sfxPlayer;
      case AudioType.voice:
        return _instance.voicePlayer;
    }
  }

  ExtendedAudioPlayer getExtendedAudioPlayer(AudioType type) {
    switch (type) {
      case AudioType.bgm:
        return bgmPlayer;
      case AudioType.sfx:
        return sfxPlayer;
      case AudioType.voice:
        return voicePlayer;
    }
  }

  /// 볼륨은 0.0 ~ 1.0 사이의 값으로 설정합니다.
  /// 볼륨이 0.0이면 소리가 나지 않습니다.
  /// 볼륨이 1.0이면 최대 볼륨으로 소리가 나옵니다.
  static void setVolume(AudioType type, double volume) {
    _instance.getExtendedAudioPlayer(type).setVolume(volume);
  }

  static double getVolume(AudioType type) {
    return _instance.getExtendedAudioPlayer(type).getVolume();
  }

  /// 사운드 파일명(확장자 포함)을 인자로 받아 사운드를 재생합니다.
  static Future<void> play(FlutterFileLocation fileLocation, AudioType type, String filePath, {bool? loop}) async {
    //_instance._logger.info('play: $filePath ($type)');
    if (!filePath.contains('.')) filePath += _defaultExtension;

    try {
      var extendedAudioPlayer = _instance.getExtendedAudioPlayer(type);
      extendedAudioPlayer.play(fileLocation, filePath, loop: loop);
    } catch (e) {
      _instance._logger.severe('Error playing sound: $e');
    }
  }

  static Future<void> playBgmAsset(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.assets, AudioType.bgm, sound, loop: loop);
  static Future<void> playSfxAsset(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.assets, AudioType.sfx, sound, loop: loop);
  static Future<void> playVoiceAsset(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.assets, AudioType.voice, sound, loop: loop);

  static Future<void> playBgmFile(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.file, AudioType.bgm, sound, loop: loop);
  static Future<void> playSfxFile(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.file, AudioType.sfx, sound, loop: loop);
  static Future<void> playVoiceFile(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.file, AudioType.voice, sound, loop: loop);

  static Future<void> playBgmHttp(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.http, AudioType.bgm, sound, loop: loop);
  static Future<void> playSfxHttp(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.http, AudioType.sfx, sound, loop: loop);
  static Future<void> playVoiceHttp(String sound, {bool? loop}) async =>
      await play(FlutterFileLocation.http, AudioType.voice, sound, loop: loop);

  static Future<void> stop(AudioType type) async => await _instance.getExtendedAudioPlayer(type).stop();
  static Future<void> pause(AudioType type) async => await _instance.getExtendedAudioPlayer(type).pause();
  static Future<void> resume(AudioType type) async => await _instance.getExtendedAudioPlayer(type).resume();
  static Future<void> toggle(AudioType type) async => await _instance.getExtendedAudioPlayer(type).toggle();
  static Future<void> playLastAudio(AudioType type) async => await _instance.getExtendedAudioPlayer(type).playLastAudio();

  static Future<void> stopBgm() async => await stop(AudioType.bgm);
  static Future<void> stopSfx() async => await stop(AudioType.sfx);
  static Future<void> stopVoice() async => await stop(AudioType.voice);

  static Future<void> pauseBgm() async => await pause(AudioType.bgm);
  static Future<void> pauseSfx() async => await pause(AudioType.sfx);
  static Future<void> pauseVoice() async => await pause(AudioType.voice);

  static Future<void> resumeBgm() async => await resume(AudioType.bgm);
  static Future<void> resumeSfx() async => await resume(AudioType.sfx);
  static Future<void> resumeVoice() async => await resume(AudioType.voice);

  static Future<void> toggleBgm() async => await toggle(AudioType.bgm);
  static Future<void> toggleSfx() async => await toggle(AudioType.sfx);
  static Future<void> toggleVoice() async => await toggle(AudioType.voice);

  static Future<void> playLastBgm() async => await playLastAudio(AudioType.bgm);
  static Future<void> playLastSfx() async => await playLastAudio(AudioType.sfx);
  static Future<void> playLastVoice() async => await playLastAudio(AudioType.voice);

  @override
  void dispose() {
    bgmPlayer.dispose();
    sfxPlayer.dispose();
    voicePlayer.dispose();
    super.dispose();
  }
}
