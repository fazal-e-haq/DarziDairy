/// User-facing domain failures
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Failed to process database operation']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Failed to save or access local storage']);
}

class BackupFailure extends Failure {
  const BackupFailure([super.message = 'Backup or restore operation failed']);
}
