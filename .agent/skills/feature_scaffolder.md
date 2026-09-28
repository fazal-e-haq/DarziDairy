# Skill: Feature Scaffolder

## Description
This skill provides an automated, deterministic step-by-step procedure for scaffolding new feature slices in `lib/features/<feature_name>/` adhering strictly to Tailor Master's Feature-First Clean Architecture.

---

## Input Parameters
- `FEATURE_NAME`: Snake_case name of the feature (e.g., `suppliers`, `catalog`, `alterations`).
- `ENTITY_NAME`: PascalCase domain entity name (e.g., `SupplierEntity`, `CatalogItemEntity`).

---

## Execution Workflow

### Step 1: Directory Initialization
Create the following directory layout under `lib/features/<FEATURE_NAME>/`:
```bash
lib/features/<FEATURE_NAME>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

### Step 2: Define Domain Entity (`domain/entities/<FEATURE_NAME>_entity.dart`)
Pure Dart entity with immutable fields and pure calculations. Zero Flutter/Isar imports.
```dart
class <ENTITY_NAME> {
  final int id;
  final String title;
  final DateTime createdAt;

  const <ENTITY_NAME>({
    required this.id,
    required this.title,
    required this.createdAt,
  });
}
```

### Step 3: Define Domain Repository Contract (`domain/repositories/i_<FEATURE_NAME>_repository.dart`)
```dart
import '../entities/<FEATURE_NAME>_entity.dart';

abstract class I<ENTITY_NAME>Repository {
  Future<List<<ENTITY_NAME>>> getAll();
  Future<<ENTITY_NAME>?> getById(int id);
  Future<int> save(<ENTITY_NAME> entity);
  Future<void> delete(int id);
  Stream<List<<ENTITY_NAME>>> watchAll();
}
```

### Step 4: Define Data Model (`data/models/<FEATURE_NAME>_collection.dart`)
```dart
import 'package:isar/isar.dart';
import '../../domain/entities/<FEATURE_NAME>_entity.dart';

part '<FEATURE_NAME>_collection.g.dart';

@collection
class <ENTITY_NAME>Collection {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value, caseSensitive: false)
  late String title;

  late DateTime createdAt;

  <ENTITY_NAME> toEntity() => <ENTITY_NAME>(
    id: id,
    title: title,
    createdAt: createdAt,
  );

  static <ENTITY_NAME>Collection fromEntity(<ENTITY_NAME> entity) {
    return <ENTITY_NAME>Collection()
      ..id = entity.id == 0 ? Isar.autoIncrement : entity.id
      ..title = entity.title
      ..createdAt = entity.createdAt;
  }
}
```

### Step 5: Implement Local DataSource (`data/datasources/<FEATURE_NAME>_local_datasource.dart`)
```dart
import 'package:isar/isar.dart';
import '../models/<FEATURE_NAME>_collection.dart';

class <ENTITY_NAME>LocalDataSource {
  final Isar isar;

  <ENTITY_NAME>LocalDataSource(this.isar);

  Future<List<<ENTITY_NAME>Collection>> getAll() async {
    return isar.<ENTITY_NAME>Collections.where().findAll();
  }

  Future<<ENTITY_NAME>Collection?> getById(int id) async {
    return isar.<ENTITY_NAME>Collections.get(id);
  }

  Future<int> put(<ENTITY_NAME>Collection model) async {
    return isar.writeTxn(() => isar.<ENTITY_NAME>Collections.put(model));
  }

  Future<void> delete(int id) async {
    await isar.writeTxn(() => isar.<ENTITY_NAME>Collections.delete(id));
  }

  Stream<List<<ENTITY_NAME>Collection>> watchAll() {
    return isar.<ENTITY_NAME>Collections.where().watch(fireImmediately: true);
  }
}
```

### Step 6: Implement Repository (`data/repositories/<FEATURE_NAME>_repository_impl.dart`)
```dart
import '../../domain/entities/<FEATURE_NAME>_entity.dart';
import '../../domain/repositories/i_<FEATURE_NAME>_repository.dart';
import '../datasources/<FEATURE_NAME>_local_datasource.dart';
import '../models/<FEATURE_NAME>_collection.dart';

class <ENTITY_NAME>RepositoryImpl implements I<ENTITY_NAME>Repository {
  final <ENTITY_NAME>LocalDataSource dataSource;

  <ENTITY_NAME>RepositoryImpl(this.dataSource);

  @override
  Future<List<<ENTITY_NAME>>> getAll() async {
    final models = await dataSource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<<ENTITY_NAME>?> getById(int id) async {
    final model = await dataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<int> save(<ENTITY_NAME> entity) async {
    final model = <ENTITY_NAME>Collection.fromEntity(entity);
    return dataSource.put(model);
  }

  @override
  Future<void> delete(int id) => dataSource.delete(id);

  @override
  Stream<List<<ENTITY_NAME>>> watchAll() {
    return dataSource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
```

### Step 7: Build Presentation Provider (`presentation/providers/<FEATURE_NAME>_provider.dart`)
```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/<FEATURE_NAME>_entity.dart';
import '../../domain/repositories/i_<FEATURE_NAME>_repository.dart';

class <ENTITY_NAME>Provider extends ChangeNotifier {
  final I<ENTITY_NAME>Repository repository;
  StreamSubscription<List<<ENTITY_NAME>>>? _subscription;

  List<<ENTITY_NAME>> _items = [];
  bool _isLoading = false;

  List<<ENTITY_NAME>> get items => _items;
  bool get isLoading => _isLoading;

  <ENTITY_NAME>Provider({required this.repository}) {
    _initWatcher();
  }

  void _initWatcher() {
    _isLoading = true;
    notifyListeners();
    _subscription = repository.watchAll().listen((data) {
      _items = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

### Step 8: Verification
1. Export model schema in `lib/core/database/isar_collections.dart`.
2. Register collection in `IsarService.instance.init()`.
3. Run `dart run build_runner build --delete-conflicting-outputs`.
4. Run `flutter analyze` to ensure 0 lint errors.
