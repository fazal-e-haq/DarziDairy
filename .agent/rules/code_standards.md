# Code Standards & Clean Architecture Rules

## 1. Architectural Layers & Contracts
1. **Domain Layer:** Pure Dart. Zero Flutter UI dependencies. Contains pure entities and abstract repository interfaces (`i_customer_repository.dart`, etc.).
2. **Data Layer:** Implements domain repository contracts. Uses local datasources (Isar DB, local disk file storage). Converts Isar collections to domain entities.
3. **Presentation Layer:** Contains UI screens, modular widgets, and Provider state management (`ChangeNotifier`). Never calls Isar directly; interacts strictly with repository contracts or domain providers.

## 2. Immutability & Safety
- Models and Entities should favor immutable properties (`final`).
- Null safety must be strictly enforced. Avoid force unwrap (`!`) unless proven non-null by preceding assertions.
- Use explicit return types for all public methods and functions.

## 3. Error Handling
- Use `Either` or structured Result wrappers/Exceptions for local IO and DB transactions.
- Catch platform exceptions during file operations and map them to domain `Failure` objects for clean UI presentation.
