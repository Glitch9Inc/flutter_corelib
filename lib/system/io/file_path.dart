import 'package:path_provider/path_provider.dart';

enum FileSource {
  tempDir,
  appDir,
  assetsDir,
  localDrive,
  http,
}

class FilePath {
  final FileSource source;
  final String fileName;
  final String extension;
  final String filePath;
  String? _fullPath;

  FilePath({
    required this.source,
    required this.filePath,
  })  : fileName = filePath.split('/').last,
        extension = filePath.split('.').last;

  Future<String> getPath() async {
    if (_fullPath != null) return _fullPath!;

    String? basePath = await _resolveBasePath();

    if (basePath == null) {
      _fullPath = filePath;
    } else {
      _fullPath = '$basePath/$filePath';
    }

    return _fullPath!;
  }

  Future<String?> _resolveBasePath() async {
    switch (source) {
      case FileSource.tempDir:
        return (await getTemporaryDirectory()).path;
      case FileSource.appDir:
        return (await getApplicationDocumentsDirectory()).path;
      case FileSource.assetsDir:
        return null;
      case FileSource.localDrive:
        return null;
      case FileSource.http:
        return null;
    }
  }
}
