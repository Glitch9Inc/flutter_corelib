// import 'package:flutter_corelib/flutter_corelib.dart';

// class AudioManager extends GetxController {
//   static const kDefaultExtension = '.mp3';

//   AudioManager._internal();
//   static final AudioManager _instance = AudioManager._internal();
//   factory AudioManager() => _instance;

//   final Logger _logger = Logger('AudioManager');

//   static JustAudioPlayer get bgm => _instance.bgmPlayer;
//   static JustAudioPlayer get sfx => _instance.sfxPlayer;
//   static JustAudioPlayer get voice => _instance.voicePlayer;

//   final sfxPlayer = JustAudioPlayer('SFX', defaultLoop: false, allowMultipleAudios: true);
//   final bgmPlayer = JustAudioPlayer('BGM', defaultLoop: true, fadeOutOnStop: true, ignoreSameAudio: true);
//   final voicePlayer = JustAudioPlayer('VOICE', defaultLoop: false, allowMultipleAudios: true);

//   static bool get isInit => _instance.bgmPlayer.isInit && _instance.sfxPlayer.isInit && _instance.voicePlayer.isInit;

//   static JustAudioPlayer getAudioPlayer(AudioChannelType type) {
//     switch (type) {
//       case AudioChannelType.bgm:
//         return _instance.bgmPlayer;
//       case AudioChannelType.sfx:
//         return _instance.sfxPlayer;
//       case AudioChannelType.voice:
//         return _instance.voicePlayer;
//     }
//   }

//   JustAudioPlayer getExtendedAudioPlayer(AudioChannelType type) {
//     switch (type) {
//       case AudioChannelType.bgm:
//         return bgmPlayer;
//       case AudioChannelType.sfx:
//         return sfxPlayer;
//       case AudioChannelType.voice:
//         return voicePlayer;
//     }
//   }

//   /// 볼륨은 0.0 ~ 1.0 사이의 값으로 설정합니다.
//   /// 볼륨이 0.0이면 소리가 나지 않습니다.
//   /// 볼륨이 1.0이면 최대 볼륨으로 소리가 나옵니다.
//   static void setVolume(AudioChannelType type, double volume) {
//     _instance.getExtendedAudioPlayer(type).setVolume(volume);
//   }

//   static double getVolume(AudioChannelType type) {
//     return _instance.getExtendedAudioPlayer(type).getVolume();
//   }

//   /// 사운드 파일명(확장자 포함)을 인자로 받아 사운드를 재생합니다.
//   static Future<void> play(FileSource fileLocation, AudioChannelType type, String filePath, {bool? loop}) async {
//     //_instance._logger.info('play: $filePath ($type)');
//     if (!filePath.contains('.')) filePath += kDefaultExtension;

//     try {
//       var extendedAudioPlayer = _instance.getExtendedAudioPlayer(type);
//       extendedAudioPlayer.play(fileLocation, filePath, loop: loop);
//     } catch (e) {
//       _instance._logger.severe('Error playing sound: $e');
//     }
//   }

//   static Future<void> playBgmAsset(String sound, {bool? loop}) async => await play(FileSource.assetsDir, AudioChannelType.bgm, sound, loop: loop);
//   static Future<void> playSfxAsset(String sound, {bool? loop}) async => await play(FileSource.assetsDir, AudioChannelType.sfx, sound, loop: loop);
//   static Future<void> playVoiceAsset(String sound, {bool? loop}) async => await play(FileSource.assetsDir, AudioChannelType.voice, sound, loop: loop);

//   static Future<void> playBgmFile(String sound, {bool? loop}) async => await play(FileSource.localDrive, AudioChannelType.bgm, sound, loop: loop);
//   static Future<void> playSfxFile(String sound, {bool? loop}) async => await play(FileSource.localDrive, AudioChannelType.sfx, sound, loop: loop);
//   static Future<void> playVoiceFile(String sound, {bool? loop}) async => await play(FileSource.localDrive, AudioChannelType.voice, sound, loop: loop);

//   static Future<void> playBgmHttp(String sound, {bool? loop}) async => await play(FileSource.http, AudioChannelType.bgm, sound, loop: loop);
//   static Future<void> playSfxHttp(String sound, {bool? loop}) async => await play(FileSource.http, AudioChannelType.sfx, sound, loop: loop);
//   static Future<void> playVoiceHttp(String sound, {bool? loop}) async => await play(FileSource.http, AudioChannelType.voice, sound, loop: loop);

//   static Future<void> stop(AudioChannelType type) async => await _instance.getExtendedAudioPlayer(type).stop();
//   static Future<void> pause(AudioChannelType type) async => await _instance.getExtendedAudioPlayer(type).pause();
//   static Future<void> resume(AudioChannelType type) async => await _instance.getExtendedAudioPlayer(type).resume();
//   static Future<void> toggle(AudioChannelType type) async => await _instance.getExtendedAudioPlayer(type).toggle();
//   static Future<void> playLastAudio(AudioChannelType type) async => await _instance.getExtendedAudioPlayer(type).playLastAudio();

//   static Future<void> stopBgm() async => await stop(AudioChannelType.bgm);
//   static Future<void> stopSfx() async => await stop(AudioChannelType.sfx);
//   static Future<void> stopVoice() async => await stop(AudioChannelType.voice);

//   static Future<void> pauseBgm() async => await pause(AudioChannelType.bgm);
//   static Future<void> pauseSfx() async => await pause(AudioChannelType.sfx);
//   static Future<void> pauseVoice() async => await pause(AudioChannelType.voice);

//   static Future<void> resumeBgm() async => await resume(AudioChannelType.bgm);
//   static Future<void> resumeSfx() async => await resume(AudioChannelType.sfx);
//   static Future<void> resumeVoice() async => await resume(AudioChannelType.voice);

//   static Future<void> toggleBgm() async => await toggle(AudioChannelType.bgm);
//   static Future<void> toggleSfx() async => await toggle(AudioChannelType.sfx);
//   static Future<void> toggleVoice() async => await toggle(AudioChannelType.voice);

//   static Future<void> playLastBgm() async => await playLastAudio(AudioChannelType.bgm);
//   static Future<void> playLastSfx() async => await playLastAudio(AudioChannelType.sfx);
//   static Future<void> playLastVoice() async => await playLastAudio(AudioChannelType.voice);

//   @override
//   void dispose() {
//     bgmPlayer.dispose();
//     sfxPlayer.dispose();
//     voicePlayer.dispose();
//     super.dispose();
//   }
// }
