import 'dart:io' as io;

import 'package:flutter_corelib/flutter_corelib.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioFile {
  static const int fileTooSmallKb = 50;
  final FileLocation location;
  final String path;
  final String? downloadUrl;
  final AudioType type;
  final AudioPlayer player;

  AudioFile(
      {required this.location,
      required this.path,
      required this.type,
      this.downloadUrl})
      : player = getAudioPlayer(type);

  static AudioPlayer getAudioPlayer(AudioType type) {
    switch (type) {
      case AudioType.bgm:
        return SoundManager.bgm;
      case AudioType.sfx:
        return SoundManager.sfx;
      case AudioType.voice:
        return SoundManager.voice;
    }
  }

  Future<void> play() async {
    if (!await _exists()) throw Exception('File does not exist');
    switch (location) {
      case FileLocation.assets:
        await player.setAsset(path);
        break;
      case FileLocation.file:
        await player.setFilePath(path);
        break;
      case FileLocation.http:
        await player.setUrl(path);
    }
    await player.play();
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<bool> _exists() async {
    if (path.isEmpty) throw Exception('Path is empty');
    switch (location) {
      case FileLocation.assets:
        return await rootBundle
            .load(path)
            .then((value) => true)
            .catchError((e) => false);
      case FileLocation.file:
        bool exists = await io.File(path).exists();
        if (!exists && downloadUrl != null) {
          exists = await _downloadFile();
        }
        return exists;

      case FileLocation.http:
        // TODO: Implement network file check
        return true;
    }
  }

  Future<bool> _downloadFile() async {
    if (downloadUrl.isNullOrEmpty) return false;

    try {
      final io.Directory persistentDataPath =
          await getApplicationDocumentsDirectory();
      final io.Directory downloadDir =
          io.Directory('${persistentDataPath.path}/$path');
      if (!downloadDir.existsSync()) {
        downloadDir.createSync(recursive: true);
      }

      final io.File file = io.File('${downloadDir.path}/$path');

      if (file.existsSync()) {
        // check if the file is too small.
        // if it's too small, it means it's a corrupted file. (probably disconnected during download)
        // so delete it if it's too small.
        final int fileSize = await file.length();
        if (fileSize < fileTooSmallKb) {
          file.deleteSync();
        } else {
          return true;
        }
      }

      final response = await http.get(Uri.parse(downloadUrl!));
      if (response.statusCode == 200) {
        final persistentDataPath = await getApplicationDocumentsDirectory();
        final filePath = '${persistentDataPath.path}/${path}';
        final file = io.File(filePath);
        await file.writeAsBytes(response.bodyBytes);
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
