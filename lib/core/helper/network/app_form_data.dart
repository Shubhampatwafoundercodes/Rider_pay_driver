import 'package:dio/dio.dart';

class AppFormData {
  /// Simple text fields
  static FormData fromMap(Map<String, dynamic> fields) {
    return FormData.fromMap(fields);
  }

  /// Upload with file
  static Future<FormData> withFile({
    required Map<String, dynamic> fields,
    required String fileKey,
    required String filePath,
    String? fileName,
  }) async {
    final map = Map<String, dynamic>.from(fields);
    map[fileKey] = await MultipartFile.fromFile(filePath, filename: fileName ?? filePath.split("/").last);

    return FormData.fromMap(map);
  }

  /// Upload multiple files
  static Future<FormData> withFiles({
    required Map<String, dynamic> fields,
    required String filesKey,
    required List<String> filePaths,
  }) async {
    final map = Map<String, dynamic>.from(fields);
    map[filesKey] = await Future.wait(filePaths.map((path) async {
      return await MultipartFile.fromFile(path, filename: path.split("/").last);
    }));

    return FormData.fromMap(map);
  }
}
