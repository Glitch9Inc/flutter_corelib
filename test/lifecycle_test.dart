import 'dart:async';

import 'package:flutter_corelib/prefs/flutter_prefs.dart';
import 'package:flutter_corelib/prefs/prefs.dart';
import 'package:flutter_corelib/system/audio_manager/audio_channel.dart';
import 'package:flutter_corelib/system/io/file_path.dart';
import 'package:flutter_corelib/system/models/awaiter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    FlutterPrefs.setPreferencesForTesting(
      await SharedPreferences.getInstance(),
    );
    Prefs.clearCache();
  });

  tearDown(FlutterPrefs.resetForTesting);

  test('Awaiter cancels polling on success and validates durations', () async {
    var ready = false;
    Timer(const Duration(milliseconds: 5), () => ready = true);
    await Awaiter.waitUntil(
      () => ready,
      interval: const Duration(milliseconds: 1),
      timeout: const Duration(milliseconds: 100),
    );

    expect(
      () => Awaiter.waitUntil(
        () => false,
        interval: Duration.zero,
      ),
      throwsArgumentError,
    );
  });

  test('audio overlap creates owned players and stop disposes all', () async {
    final players = <_FakePlayer>[];
    final channel = AudioChannel<_FakePlayer>(
      'test-overlap',
      defaultLoop: false,
      allowAudioOverlap: true,
      playerBuilder: () {
        final player = _FakePlayer();
        players.add(player);
        return player;
      },
    );
    await channel.init();

    await channel.play(FileSource.assetsDir, 'first.mp3');
    await channel.play(FileSource.assetsDir, 'second.mp3');
    expect(players, hasLength(2));

    await channel.setVolume(3);
    expect(channel.getVolume(), 1);
    await channel.stop();
    expect(players.every((player) => player.disposed), isTrue);
  });

  test('pausing keeps a completion-aware player available to resume', () async {
    late _CompletionAwareFakePlayer player;
    final channel = AudioChannel<_CompletionAwareFakePlayer>(
      'test-resume',
      defaultLoop: false,
      playerBuilder: () => player = _CompletionAwareFakePlayer(),
    );
    await channel.init();

    final playFuture = channel.play(FileSource.assetsDir, 'bgm.mp3');
    await Future<void>.delayed(Duration.zero);
    await channel.pause();
    await playFuture;

    expect(player.disposed, isFalse);
    final resumeFuture = channel.resume();
    await Future<void>.delayed(Duration.zero);
    expect(player.playing, isTrue);

    await channel.pause();
    await resumeFuture;
    await channel.stop();
  });
}

class _FakePlayer with AudioChannelPlayer {
  bool disposed = false;
  bool _playing = false;
  double _volume = 1;

  @override
  bool get playing => _playing;

  @override
  double get volume => _volume;

  @override
  Future<void> dispose() async => disposed = true;

  @override
  Future<void> pause() async => _playing = false;

  @override
  Future<void> play() async => _playing = true;

  @override
  Future<void> resume() async => _playing = true;

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setAsset(String assetPath) async {}

  @override
  Future<void> setFilePath(String filePath) async {}

  @override
  Future<void> setLoop(bool loop) async {}

  @override
  Future<void> setUrl(String url) async {}

  @override
  Future<void> setVolume(double volume) async => _volume = volume;

  @override
  Future<void> stop() async => _playing = false;
}

class _CompletionAwareFakePlayer extends _FakePlayer
    implements AudioChannelCompletion {
  final _completed = StreamController<void>.broadcast();
  Completer<void>? _playCompleter;

  @override
  Stream<void> get onCompleted => _completed.stream;

  @override
  Future<void> play() {
    _playing = true;
    _playCompleter = Completer<void>();
    return _playCompleter!.future;
  }

  @override
  Future<void> pause() async {
    _playing = false;
    _finishPlayWait();
  }

  @override
  Future<void> resume() => play();

  @override
  Future<void> stop() async {
    _playing = false;
    _finishPlayWait();
  }

  @override
  Future<void> dispose() async {
    await _completed.close();
    await super.dispose();
  }

  void _finishPlayWait() {
    final completer = _playCompleter;
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
