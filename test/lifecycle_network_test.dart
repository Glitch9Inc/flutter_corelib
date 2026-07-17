import 'dart:async';

import 'package:dart_corelib/models/result.dart';
import 'package:flutter_corelib/network/services/api_data_service.dart';
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

  test('API service retains typed failures and emits deleted id', () async {
    final service = _FakeService();
    final deletedId = expectLater(service.onDeletedId, emits('item-1'));

    final missing = await service.retrieveResult('missing');
    expect(missing.isFailure, isTrue);
    expect(
      (missing.error as APIDataException).kind,
      APIDataFailureKind.notFound,
    );

    final created = await service.retrieveOrCreate('missing');
    expect(created, 'missing');

    expect(await service.delete('item-1'), isTrue);
    await deletedId;
    await service.dispose();

    final afterDispose = await service.listResult(1);
    expect(afterDispose.isFailure, isTrue);
    expect(afterDispose.error, isA<StateError>());
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

class _FakeService extends APIDataService<String> {
  @override
  Future<Result<String>> createInternal({String? id}) async {
    return Result<String>.success(data: id ?? 'created');
  }

  @override
  Future<Result<void>> deleteInternal(String id) async {
    return Result<void>.success();
  }

  @override
  Future<Result<List<String>>> listInternal(int count) async {
    return Result<List<String>>.success(data: <String>['value']);
  }

  @override
  Future<Result<String>> retrieveInternal(String id) async {
    if (id == 'missing') {
      return Result<String>.error(
        const APIDataException(
          APIDataFailureKind.notFound,
          'not found',
        ),
      );
    }
    return Result<String>.success(data: id);
  }
}
