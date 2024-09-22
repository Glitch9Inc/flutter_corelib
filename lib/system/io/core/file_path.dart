import 'package:path_provider/path_provider.dart';

import 'directory_type.dart';

class FilePath {
  final DirectoryType directoryType;
  final String fileName;
  final String fileExtension;
  final String filePath;
  String? _fullPath;

  FilePath({
    required this.directoryType,
    required this.filePath,
  })  : fileName = filePath.split('/').last,
        fileExtension = filePath.split('.').last;

  Future<String> getFullPath() async {
    if (_fullPath != null) return _fullPath!;

    String? dirPath = await _getDirectoryPath();

    if (dirPath == null) {
      throw Exception('Failed to get directory path of type: $directoryType');
    }

    _fullPath = '$dirPath/$filePath';
    return _fullPath!;
  }

  Future<String?> _getDirectoryPath() async {
    switch (directoryType) {
      case DirectoryType.temp:
        return (await getTemporaryDirectory()).path;
      case DirectoryType.persistentDataPath:
        return (await getApplicationDocumentsDirectory()).path;
    }
  }
}
