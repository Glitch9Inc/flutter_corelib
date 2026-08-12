import 'dart:async';

import 'package:flutter_corelib/prefs/flutter_prefs.dart';
import 'package:flutter_corelib/prefs/prefs.dart';
import 'package:flutter_corelib/system/audio_manager/base_audio_manager.dart';
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

  test('a player that fails to start is dropped, not left in the pool',
      () async {
    final players = <_FakePlayer>[];
    var failNext = true;
    final channel = AudioChannel<_FakePlayer>(
      'test-broken',
      defaultLoop: false,
      playerBuilder: () {
        final player = _FakePlayer(failOnPlay: failNext);
        failNext = false;
        players.add(player);
        return player;
      },
    );
    await channel.init();

    await expectLater(
      channel.play(FileSource.assetsDir, 'first.mp3'),
      throwsStateError,
    );
    expect(players.single.disposed, isTrue);

    // The next sound must not be routed back into the broken player.
    await channel.play(FileSource.assetsDir, 'second.mp3');
    expect(players, hasLength(2));
    expect(players.last.playing, isTrue);
  });

  test('completed players are recycled and never shared by overlapping plays',
      () async {
    final players = <_CompletionAwareFakePlayer>[];
    final channel = AudioChannel<_CompletionAwareFakePlayer>(
      'test-recycle',
      defaultLoop: false,
      allowAudioOverlap: true,
      playerBuilder: () {
        final player = _CompletionAwareFakePlayer(completeImmediately: true);
        players.add(player);
        return player;
      },
    );
    await channel.init();

    await channel.play(FileSource.assetsDir, 'first.mp3');
    await Future<void>.delayed(Duration.zero);
    expect(players, hasLength(1));
    expect(players.single.playing, isFalse, reason: 'recycled for reuse');
    expect(players.single.disposed, isFalse);

    await Future.wait(<Future<void>>[
      channel.play(FileSource.assetsDir, 'second.mp3'),
      channel.play(FileSource.assetsDir, 'third.mp3'),
    ]);

    expect(players, hasLength(2), reason: 'idle player reused, not shared');
    expect(players.first.assets, <String>['first.mp3', 'second.mp3']);
    expect(players.last.assets, <String>['third.mp3']);
    await channel.stop();
  });

  test('resume does not restart a recycled player', () async {
    late _CompletionAwareFakePlayer player;
    final channel = AudioChannel<_CompletionAwareFakePlayer>(
      'test-idle-resume',
      defaultLoop: false,
      playerBuilder: () =>
          player = _CompletionAwareFakePlayer(completeImmediately: true),
    );
    await channel.init();

    await channel.play(FileSource.assetsDir, 'sfx.mp3');
    await Future<void>.delayed(Duration.zero);
    expect(player.playing, isFalse);

    await channel.resume();
    expect(player.playing, isFalse, reason: 'idle, not paused');
    await channel.stop();
  });

  test('volume is usable before init and survives it', () async {
    final channel = AudioChannel<_FakePlayer>(
      'test-preinit',
      defaultLoop: false,
      playerBuilder: _FakePlayer.new,
    );

    // The settings UI and the lobby BGM controller both read this while
    // AudioManager.init() is still in flight.
    expect(channel.getVolume(), 1);
    await channel.setVolume(0.4);

    await channel.init();
    expect(channel.getVolume(), 0.4, reason: 'init must not reset the volume');
  });

  test('audio manager init is idempotent and dispose clears isInit', () async {
    final manager = _FakeAudioManager();
    expect(manager.isInit, isFalse);

    await Future.wait(<Future<void>>[manager.init(), manager.init()]);
    expect(manager.isInit, isTrue);

    await manager.dispose();
    expect(manager.isInit, isFalse, reason: 'channels reject calls once gone');

    await manager.init();
    expect(manager.isInit, isTrue, reason: 're-init must be possible');
  });

  test('a saturated pool reclaims the oldest player', () async {
    final players = <_FakePlayer>[];
    final channel = AudioChannel<_FakePlayer>(
      'test-cap',
      defaultLoop: false,
      allowAudioOverlap: true,
      maxPlayers: 2,
      playerBuilder: () {
        final player = _FakePlayer();
        players.add(player);
        return player;
      },
    );
    await channel.init();

    // These fakes never report completion, so they stay busy forever.
    await channel.play(FileSource.assetsDir, 'first.mp3');
    await channel.play(FileSource.assetsDir, 'second.mp3');
    await channel.play(FileSource.assetsDir, 'third.mp3');

    expect(players, hasLength(3));
    expect(players.first.disposed, isTrue);
    expect(players.last.playing, isTrue);
    await channel.stop();
  });
}

class _FakeAudioManager extends BaseAudioManager<_FakePlayer> {
  @override
  _FakePlayer createPlayer() => _FakePlayer();
}

class _FakePlayer with AudioChannelPlayer {
  _FakePlayer({this.failOnPlay = false});

  final bool failOnPlay;
  final List<String> assets = <String>[];
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
  Future<void> play() async {
    if (failOnPlay) throw StateError('playback failed');
    _playing = true;
  }

  @override
  Future<void> resume() async => _playing = true;

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> setAsset(String assetPath) async => assets.add(assetPath);

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
  _CompletionAwareFakePlayer({this.completeImmediately = false});

  final bool completeImmediately;
  final _completed = StreamController<void>.broadcast();
  Completer<void>? _playCompleter;

  @override
  Stream<void> get onCompleted => _completed.stream;

  @override
  Future<void> play() {
    _playing = true;
    if (completeImmediately) {
      scheduleMicrotask(() {
        if (!_completed.isClosed) _completed.add(null);
      });
      return Future<void>.value();
    }
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
