import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'sound_manager.dart';

class AudioFile {
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
      case FileLocation.network:
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
        bool exists = await File(path).exists();
        if (!exists && downloadUrl != null) {
          exists = await _downloadFile();
        }
        return exists;

      case FileLocation.network:
        // TODO: Implement network file check
        return true;
    }
  }

  Future<bool> _downloadFile() async {
    if (downloadUrl == null) return false;

    try {
      final response = await http.get(Uri.parse(downloadUrl!));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${path.split('/').last}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error downloading file: $e');
      return false;
    }
  }
}
