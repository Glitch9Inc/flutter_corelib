import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_framework/flutter_game_framework.dart';
import 'package:flutter_corelib/core/audio/extended_audio_player.dart';

export 'audio_type.dart';

class AudioFile {
  static const int fileTooSmallKb = 50;
  final FlutterFileLocation location;
  final String path;
  final String? downloadUrl;
  final AudioType type;
  final ExtendedAudioPlayer player;

  AudioFile({required this.location, required this.path, required this.type, this.downloadUrl})
      : player = AudioManager.getAudioPlayer(type);

  Future<void> play() async {
    if (!await _exists()) throw Exception('File does not exist');

    await player.play(location, path);
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<bool> _exists() async {
    if (path.isEmpty) throw Exception('Path is empty');
    switch (location) {
      case FlutterFileLocation.assets:
        return await rootBundle.load(path).then((value) => true).catchError((e) => false);
      case FlutterFileLocation.file:
        bool exists = await io.File(path).exists();
        if (!exists && downloadUrl != null) {
          exists = await _downloadFile();
        }
        return exists;

      case FlutterFileLocation.http:
        // TODO: Implement network file check
        return true;
    }
  }

  Future<bool> _downloadFile() async {
    if (downloadUrl.isNullOrEmpty) return false;

    final Dio dio = Dio();

    try {
      final io.Directory persistentDataPath = await getApplicationDocumentsDirectory();
      final io.Directory downloadDir = io.Directory('${persistentDataPath.path}/$path');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      final io.File file = io.File('${downloadDir.path}/$path');

      if (file.existsSync()) {
        final int fileSize = await file.length();
        if (fileSize < fileTooSmallKb) {
          file.deleteSync();
        } else {
          return true;
        }
      }

      final String filePath = '${downloadDir.path}/$path';

      final Response response = await dio.download(
        downloadUrl!,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Progress update (optional)
            print('${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printError(info: 'Error downloading file: $e');
    }

    return false;
  }
}
