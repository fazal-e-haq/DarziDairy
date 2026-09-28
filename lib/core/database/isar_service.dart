import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/customers/data/models/customer_collection.dart';
import '../../features/orders/data/models/order_collection.dart';
import '../../features/diary/data/models/expense_collection.dart';
import '../errors/exceptions.dart';

/// Production Isar database singleton managing thread-safe initialization,
/// Android 16KB page-size safety, collection registration, and storage compaction.
class IsarService {
  IsarService._internal();

  /// Global singleton instance
  static final IsarService instance = IsarService._internal();

  static const String databaseName = 'tailor_master_db';

  Isar? _isar;
  Completer<Isar>? _initCompleter;

  /// Returns active Isar instance.
  /// Throws [DatabaseException] if accessed prior to [init].
  Isar get isar {
    final active = _isar;
    if (active == null || !active.isOpen) {
      throw const DatabaseException(
        'Isar database is not initialized or has been closed. Call IsarService.instance.init() first.',
      );
    }
    return active;
  }

  /// True if database is actively opened and available.
  bool get isOpen => _isar != null && _isar!.isOpen;

  /// Thread-safe, single-instance initialization with mutex-like Completer guard
  /// to eliminate race conditions during concurrent startup calls.
  ///
  /// Satisfies Android 15+ 16KB physical memory page alignment via the underlying
  /// `isar_flutter_libs` C++ runtime.
  Future<Isar> init({String name = databaseName}) async {
    // 1. If already open and matches requested name, return immediately
    if (_isar != null && _isar!.isOpen && _isar!.name == name) {
      return _isar!;
    }

    // 2. If another initialization is currently in-flight, await the same future
    if (_initCompleter != null && !_initCompleter!.isCompleted) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<Isar>();

    try {
      // 3. Check if instance already exists across isolates
      final existingInstance = Isar.getInstance(name);
      if (existingInstance != null && existingInstance.isOpen) {
        _isar = existingInstance;
        _initCompleter!.complete(_isar!);
        return _isar!;
      }

      // 4. Dynamically acquire sandboxed application documents directory
      final documentsDirectory = await getApplicationDocumentsDirectory();

      // 5. Open Isar database with all schemas in a single atomic initialization
      _isar = await Isar.open(
        [
          CustomerCollectionSchema,
          OrderCollectionSchema,
          ExpenseCollectionSchema,
        ],
        directory: documentsDirectory.path,
        name: name,
        inspector: kDebugMode,
      );

      _initCompleter!.complete(_isar!);
      return _isar!;
    } catch (error, stackTrace) {
      final dbException = DatabaseException(
        'Critical failure opening Isar database: $error',
      );
      if (!_initCompleter!.isCompleted) {
        _initCompleter!.completeError(dbException, stackTrace);
      }
      _initCompleter = null;
      throw dbException;
    } finally {
      // Reset completer handle once completed
      if (_isar != null && _isar!.isOpen) {
        _initCompleter = null;
      }
    }
  }

  /// Compacts database storage by creating a defragmented replica to reclaim deleted space.
  ///
  /// If [destinationPath] is not provided, writes to a compacted backup file in the app documents dir.
  Future<File> compact({String? destinationPath}) async {
    final active = isar;
    final dir = await getApplicationDocumentsDirectory();
    final targetPath = destinationPath ?? '${dir.path}/${databaseName}_compacted.isar';
    final targetFile = File(targetPath);

    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    await active.copyToFile(targetPath);
    return targetFile;
  }

  /// Returns total database storage size in bytes.
  Future<int> getSize({bool includeIndexes = true}) async {
    final active = isar;
    return active.getSize(includeIndexes: includeIndexes);
  }

  /// Clears all stored records across all collections (used during clean backup restores).
  Future<void> clearAll() async {
    final active = isar;
    await active.writeTxn(() async {
      await active.clear();
    });
  }

  /// Safely closes the database instance and frees native memory.
  Future<void> close() async {
    final active = _isar;
    if (active != null && active.isOpen) {
      await active.close();
      _isar = null;
      _initCompleter = null;
    }
  }
}
