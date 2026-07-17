import 'package:logging/logging.dart';

import 'audio_channel.dart';
import '../diagnostics/debug_log.dart';
import '../io/file_path.dart';

export 'audio_channel.dart';

enum AudioChannelType {
  bgm,
  sfx,
  voice,
}

abstract class BaseAudioManager<TAudioPlayer extends AudioChannelPlayer> {
  static const kDefaultExtension = '.mp3';
  final _logger = Logger('AudioManager');

  // override this getter in the subclass
  TAudioPlayer createPlayer();

  AudioChannel<TAudioPlayer> get bgm => bgmChannel;
  AudioChannel<TAudioPlayer> get sfx => sfxChannel;
  AudioChannel<TAudioPlayer> get voice => voiceChannel;

  late final sfxChannel = AudioChannel('SFX',
      defaultLoop: false,
      allowAudioOverlap: true,
      playerBuilder: () => createPlayer());
  late final bgmChannel = AudioChannel('BGM',
      defaultLoop: true,
      fadeAudioOnStop: true,
      ignoreSameAudio: true,
      playerBuilder: () => createPlayer());
  late final voiceChannel = AudioChannel('VOICE',
      defaultLoop: false,
      allowAudioOverlap: true,
      playerBuilder: () => createPlayer());

  bool get isInit => _isInit;
  bool _isInit = false;

  Future<void> init() async {
    try {
      final futures = [
        bgmChannel.init(),
        sfxChannel.init(),
        voiceChannel.init(),
      ];

      await Future.wait(futures);

      _isInit = true;
    } catch (e, stackTrace) {
      Debug.severe('Failed to initialize audio',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> dispose() async {
    try {
      final futures = [
        bgmChannel.dispose(),
        sfxChannel.dispose(),
        voiceChannel.dispose(),
      ];

      await Future.wait(futures);
    } catch (e, stackTrace) {
      _isInit = false;
      Debug.severe('Failed to dispose audio', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  AudioChannel<TAudioPlayer> getChannel(AudioChannelType type) {
    switch (type) {
      case AudioChannelType.bgm:
        return bgmChannel;
      case AudioChannelType.sfx:
        return sfxChannel;
      case AudioChannelType.voice:
        return voiceChannel;
    }
  }

  /// 볼륨은 0.0 ~ 1.0 사이의 값으로 설정합니다.
  /// 볼륨이 0.0이면 소리가 나지 않습니다.
  /// 볼륨이 1.0이면 최대 볼륨으로 소리가 나옵니다.
  Future<void> setVolume(AudioChannelType type, double volume) =>
      getChannel(type).setVolume(volume);

  double getVolume(AudioChannelType type) {
    return getChannel(type).getVolume();
  }

  /// 사운드 파일명(확장자 포함)을 인자로 받아 사운드를 재생합니다.
  Future<void> play(
      FileSource fileLocation, AudioChannelType type, String filePath,
      {bool? loop}) async {
    // _logger.info('play: $filePath ($type)');
    if (!filePath.contains('.')) filePath += kDefaultExtension;

    try {
      var extendedAudioPlayer = getChannel(type);
      await extendedAudioPlayer.play(fileLocation, filePath, loop: loop);
    } on Object catch (e, stackTrace) {
      _logger.severe('Error playing sound', e, stackTrace);
      rethrow;
    }
  }

  Future<void> playBgmAsset(String sound, {bool? loop}) async =>
      await play(FileSource.assetsDir, AudioChannelType.bgm, sound, loop: loop);
  Future<void> playSfxAsset(String sound, {bool? loop}) async =>
      await play(FileSource.assetsDir, AudioChannelType.sfx, sound, loop: loop);
  Future<void> playVoiceAsset(String sound, {bool? loop}) async =>
      await play(FileSource.assetsDir, AudioChannelType.voice, sound,
          loop: loop);

  Future<void> playBgmFile(String sound, {bool? loop}) async =>
      await play(FileSource.localDrive, AudioChannelType.bgm, sound,
          loop: loop);
  Future<void> playSfxFile(String sound, {bool? loop}) async =>
      await play(FileSource.localDrive, AudioChannelType.sfx, sound,
          loop: loop);
  Future<void> playVoiceFile(String sound, {bool? loop}) async =>
      await play(FileSource.localDrive, AudioChannelType.voice, sound,
          loop: loop);

  Future<void> playBgmHttp(String sound, {bool? loop}) async =>
      await play(FileSource.http, AudioChannelType.bgm, sound, loop: loop);
  Future<void> playSfxHttp(String sound, {bool? loop}) async =>
      await play(FileSource.http, AudioChannelType.sfx, sound, loop: loop);
  Future<void> playVoiceHttp(String sound, {bool? loop}) async =>
      await play(FileSource.http, AudioChannelType.voice, sound, loop: loop);

  Future<void> stop(AudioChannelType type) async =>
      await getChannel(type).stop();
  Future<void> pause(AudioChannelType type) async =>
      await getChannel(type).pause();
  Future<void> resume(AudioChannelType type) async =>
      await getChannel(type).resume();
  Future<void> toggle(AudioChannelType type) async =>
      await getChannel(type).toggle();
  Future<void> playLastAudio(AudioChannelType type) async =>
      await getChannel(type).playLastAudio();

  Future<void> stopBgm() async => await stop(AudioChannelType.bgm);
  Future<void> stopSfx() async => await stop(AudioChannelType.sfx);
  Future<void> stopVoice() async => await stop(AudioChannelType.voice);

  Future<void> pauseBgm() async => await pause(AudioChannelType.bgm);
  Future<void> pauseSfx() async => await pause(AudioChannelType.sfx);
  Future<void> pauseVoice() async => await pause(AudioChannelType.voice);

  Future<void> resumeBgm() async => await resume(AudioChannelType.bgm);
  Future<void> resumeSfx() async => await resume(AudioChannelType.sfx);
  Future<void> resumeVoice() async => await resume(AudioChannelType.voice);

  Future<void> toggleBgm() async => await toggle(AudioChannelType.bgm);
  Future<void> toggleSfx() async => await toggle(AudioChannelType.sfx);
  Future<void> toggleVoice() async => await toggle(AudioChannelType.voice);

  Future<void> playLastBgm() async => await playLastAudio(AudioChannelType.bgm);
  Future<void> playLastSfx() async => await playLastAudio(AudioChannelType.sfx);
  Future<void> playLastVoice() async =>
      await playLastAudio(AudioChannelType.voice);

  // @override
  // void dispose() {
  //   bgmChannel.dispose();
  //   sfxChannel.dispose();
  //   voiceChannel.dispose();
  //   super.dispose();
  // }
}
