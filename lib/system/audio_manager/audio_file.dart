import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'audio_channel.dart';
import '../io/file_path.dart';

/// Downloads [source] into [destinationPath] or throws on failure.
typedef AudioFileDownloader = Future<void> Function(
  Uri source,
  String destinationPath,
);

class AudioFile {
  static final Logger _logger = Logger('AudioFile');
  static const int fileTooSmallKb = 50;

  final FileSource location;
  final String path;
  final String? downloadUrl;
  final AudioFileDownloader? downloader;
  final AudioChannel<dynamic> channel;
  String? _resolvedLocalPath;

  AudioFile({
    required this.location,
    required this.path,
    required this.channel,
    this.downloadUrl,
    this.downloader,
  });

  Future<void> play() async {
    if (!await _exists()) throw StateError('Audio file does not exist: $path');
    await channel.play(location, _resolvedLocalPath ?? path);
  }

  Future<void> stop() => channel.stop();

  Future<bool> _exists() async {
    if (path.trim().isEmpty) {
      throw ArgumentError.value(path, 'path', 'Must not be empty');
    }
    switch (location) {
      case FileSource.assetsDir:
        try {
          await rootBundle.load(path);
          return true;
        } on Object {
          return false;
        }
      case FileSource.http:
        return true;
      case FileSource.tempDir:
      case FileSource.appDir:
        final resolved = await FilePath(
          source: location,
          filePath: path,
        ).getPath();
        _resolvedLocalPath = resolved;
        return io.File(resolved).exists();
      case FileSource.localDrive:
        final directFile = io.File(path);
        if (await directFile.exists()) {
          _resolvedLocalPath = directFile.path;
          return true;
        }
        return downloadUrl != null && await _downloadFile();
    }
  }

  Future<bool> _downloadFile() async {
    final url = downloadUrl;
    if (url == null || url.trim().isEmpty) return false;
    final source = Uri.tryParse(url);
    if (source == null ||
        (source.scheme != 'https' && source.scheme != 'http')) {
      throw ArgumentError.value(url, 'downloadUrl', 'Invalid HTTP(S) URL');
    }
    final download = downloader;
    if (download == null) {
      _logger.warning('No AudioFileDownloader was provided for $source');
      return false;
    }

    final documents = await getApplicationDocumentsDirectory();
    final relativePath = p.normalize(path);
    if (p.isAbsolute(relativePath) || relativePath.startsWith('..')) {
      throw ArgumentError.value(path, 'path', 'Must be a safe relative path');
    }

    final file = io.File(p.join(documents.path, relativePath));
    final directory = file.parent;
    await directory.create(recursive: true);
    _resolvedLocalPath = file.path;

    if (await file.exists()) {
      final bytes = await file.length();
      if (bytes >= fileTooSmallKb * 1024) return true;
      await file.delete();
    }

    final temporary = io.File('${file.path}.part');
    if (await temporary.exists()) await temporary.delete();
    try {
      await download(source, temporary.path);
      if (!await temporary.exists()) return false;
      if (await temporary.length() < fileTooSmallKb * 1024) {
        await temporary.delete();
        return false;
      }
      await temporary.rename(file.path);
      return true;
    } on Object catch (error, stackTrace) {
      _logger.warning('Audio download failed', error, stackTrace);
      if (await temporary.exists()) await temporary.delete();
      return false;
    }
  }
}
