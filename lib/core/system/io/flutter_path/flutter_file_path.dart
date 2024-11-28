import 'package:path_provider/path_provider.dart';
import 'flutter_dir_type.dart';

class FlutterFilePath {
  final FlutterDirType directoryType;
  final String fileName;
  final String fileExtension;
  final String filePath;
  String? _fullPath;

  FlutterFilePath({
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
      case FlutterDirType.temp:
        return (await getTemporaryDirectory()).path;
      case FlutterDirType.persistentDataPath:
        return (await getApplicationDocumentsDirectory()).path;
    }
  }
}
