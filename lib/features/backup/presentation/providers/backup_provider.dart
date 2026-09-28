import 'package:flutter/foundation.dart';
import '../../data/services/backup_service.dart';

/// Provider for managing export/restore state and progress
class BackupProvider extends ChangeNotifier {
  final BackupService backupService;

  BackupProvider({required this.backupService});

  bool _isProcessing = false;
  String? _statusMessage;

  bool get isProcessing => _isProcessing;
  String? get statusMessage => _statusMessage;

  Future<bool> createBackup(String destinationPath) async {
    _isProcessing = true;
    _statusMessage = 'Creating offline backup...';
    notifyListeners();

    try {
      await backupService.exportDatabase(destinationDirectory: destinationPath);
      _statusMessage = 'Backup created successfully.';
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _statusMessage = 'Failed to create backup.';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> restoreBackup(String filePath) async {
    _isProcessing = true;
    _statusMessage = 'Restoring data...';
    notifyListeners();

    try {
      final success = await backupService.restoreDatabase(backupFilePath: filePath);
      _statusMessage = success ? 'Restored successfully.' : 'Restore failed.';
      _isProcessing = false;
      notifyListeners();
      return success;
    } catch (e) {
      _statusMessage = 'Error during restore.';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
