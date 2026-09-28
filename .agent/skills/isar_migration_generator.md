# Skill: Isar Migration Generator

## Description
This skill guides the safe, non-breaking evolution of Isar database schemas in production offline environments. Because users do not have cloud recovery, a broken schema migration can result in permanent customer Khata data loss.

---

## 1. Schema Change Rules Matrix

| Change Type | Risk Level | Isar Behavior | Required Action |
| :--- | :--- | :--- | :--- |
| **Add nullable / defaulted field** | 🟢 Low | Automatically handled. Existing records evaluate to `null` or default. | Re-run `build_runner`. |
| **Add new `@Index`** | 🟡 Medium | Indexes created on next DB open. Slight initial startup delay. | Verify startup latency on low-end test device. |
| **Remove a field** | 🟠 Moderate | Field is orphaned in storage; data is retained unless compacted. | Update code mappers; document deprecation. |
| **Rename a field** | 🔴 High | Isar treats this as **deleting** the old field and **creating** an empty new field! | **MUST write a Data Migration Routine.** |
| **Change field data type** | 🔴 High | Type mismatch causes deserialization failure or schema crash. | **MUST write a Two-Phase Migration Routine.** |

---

## 2. Safety Protocol: "Backup-Before-Migrate"

Before executing any database migration logic:
1. Always create a safety snapshot of the existing database files (`tailor_master.isar` and `.isar.lock`).
2. If migration fails or throws an exception, rollback the physical files and alert the user.

```dart
Future<void> safeMigrate(Isar isar, int oldVersion, int newVersion) async {
  final dbDir = await getApplicationDocumentsDirectory();
  final backupDir = Directory('${dbDir.path}/migration_backups/v$oldVersion');
  await backupDir.create(recursive: true);

  // Snapshot active database
  final dbFile = File('${dbDir.path}/default.isar');
  if (await dbFile.exists()) {
    await dbFile.copy('${backupDir.path}/default.isar.bak');
  }

  try {
    await _executeMigrations(isar, oldVersion, newVersion);
  } catch (e, stack) {
    // Rollback snapshot on failure
    await File('${backupDir.path}/default.isar.bak').copy(dbFile.path);
    throw DatabaseException('Migration failed from v$oldVersion to v$newVersion. Restored previous database snapshot: $e');
  }
}
```

---

## 3. Migration Procedure & Code Generator

### Step 1: Version Tracking
Store the schema version in local secure preferences (`current_schema_version`).

### Step 2: Write Schema Version Migration Script
Create `lib/core/database/migrations/migration_v<OLD>_to_v<NEW>.dart`:

```dart
import 'package:isar/isar.dart';
import '../../core/errors/exceptions.dart';

class MigrationV1ToV2 {
  static Future<void> execute(Isar isar) async {
    // Example: Migrating single 'phone' into primary & secondary structure
    await isar.writeTxn(() async {
      final customers = await isar.customerCollections.where().findAll();
      for (final customer in customers) {
        // Apply transformations
        if (customer.secondaryPhone == null) {
          customer.secondaryPhone = '';
          await isar.customerCollections.put(customer);
        }
      }
    });
  }
}
```

### Step 3: Chain Migrations in `IsarService`
```dart
class IsarService {
  static const int currentSchemaVersion = 2;

  Future<void> runPendingMigrations(Isar isar) async {
    final prefs = await SharedPreferences.getInstance();
    int storedVersion = prefs.getInt('schema_version') ?? 1;

    if (storedVersion < currentSchemaVersion) {
      if (storedVersion == 1) {
        await MigrationV1ToV2.execute(isar);
        storedVersion = 2;
        await prefs.setInt('schema_version', 2);
      }
      // Add future versions sequentially:
      // if (storedVersion == 2) { ... }
    }
  }
}
```

### Step 4: Verification Checklist
- [ ] Code generator ran: `dart run build_runner build --delete-conflicting-outputs`
- [ ] Cold launch tested with a legacy database dump loaded in test fixtures.
- [ ] Checked all existing customer records to ensure zero data was erased or nullified.
- [ ] Confirmed memory consumption remains flat throughout the migration batch.
