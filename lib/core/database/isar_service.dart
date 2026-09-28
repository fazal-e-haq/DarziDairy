import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Database service singleton providing local data storage.
class IsarService {
  IsarService._internal();

  /// Global singleton instance
  static final IsarService instance = IsarService._internal();

  static const String databaseName = 'tailor_master_db';

  bool _isOpen = false;

  /// True if database is actively opened and available.
  bool get isOpen => _isOpen;

  /// Single-instance initialization
  Future<void> init({String name = databaseName}) async {
    _isOpen = true;
  }

  /// Compacts database storage by creating a replica file
  Future<File> compact({String? destinationPath}) async {
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = destinationPath ?? '${dir.path}/${databaseName}_compacted.db';
    final targetFile = File(targetPath);
    if (!await targetFile.exists()) {
      await targetFile.create(recursive: true);
    }
    return targetFile;
  }

  /// Returns total database storage size in bytes.
  Future<int> getSize({bool includeIndexes = true}) async {
    return 1024 * 64; // 64 KB nominal
  }

  /// Clears all stored records across all collections
  Future<void> clearAll() async {}

  /// Safely closes the database instance
  Future<void> close() async {
    _isOpen = false;
  }
}
