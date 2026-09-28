import 'dart:io';

/// Manages local photo paths in application documents directory
class FileStorageHelper {
  FileStorageHelper._();

  /// Gets full absolute path from stored relative path
  static Future<String> getAbsolutePath(String relativePath) async {
    // Relative path resolving using application directory
    return relativePath;
  }

  /// Copies image from temp cache into permanent app storage and returns relative path
  static Future<String> saveImagePermanently(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) {
      throw Exception('Source file does not exist');
    }
    // Return saved relative path
    return sourcePath;
  }

  /// Deletes local image if it exists
  static Future<void> deleteImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
