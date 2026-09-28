# Architectural Rules & Layer Contracts

## 1. Core Architectural Paradigm
Tailor Master follows a **Feature-First Clean Architecture** optimized for high-performance offline mobile applications. The codebase is divided into vertical feature slices (`customers`, `orders`, `diary`, `backup`), each containing three horizontal isolation rings: `domain`, `data`, and `presentation`.

```
                  ┌─────────────────────────────────────────┐
                  │           Presentation Layer            │
                  │   (Screens, Widgets, ChangeNotifier)    │
                  └────────────────────┬────────────────────┘
                                       │ depends on
                                       ▼
                  ┌─────────────────────────────────────────┐
                  │              Domain Layer               │
                  │   (Entities, Value Objects, Contracts)  │
                  └────────────────────▲────────────────────┘
                                       │ implements
                                       │
                  ┌────────────────────┴────────────────────┐
                  │               Data Layer                │
                  │  (Isar Collections, DataSources, Impl)  │
                  └─────────────────────────────────────────┘
```

---

## 2. Inward Dependency Rule
Dependencies **MUST point strictly inward towards the Domain layer**.

1. **Domain Layer is the Core:**
   - Holds the pure business rules, entities, and domain contracts.
   - It is independent of all UI frameworks, database engines, and third-party libraries.
   - **Absolute Constraint:** Zero imports of `package:flutter/*`, `package:isar/*`, or any data-source libraries.

2. **Data Layer Implements Domain Contracts:**
   - Knows about the domain entities and implements repository interfaces defined in the domain layer.
   - Knows about Isar NoSQL models, disk files, and serializers.
   - Never exposes Isar models directly to the presentation layer; it converts collections to domain entities before returning.

3. **Presentation Layer Consumes Domain:**
   - Interacts with domain entities and repository contracts via Providers.
   - Never directly touches Isar collections or local datasources.

---

## 3. Layer Specifications & Responsibilities

### A. Domain Layer (`lib/features/<feature>/domain/`)
The domain layer encapsulates business enterprise rules and represents the single source of truth for application logic.

- **`entities/`**:
  - Immutable Dart classes representing tailoring domain models (e.g., `CustomerEntity`, `OrderEntity`, `ExpenseEntity`).
  - Must use `final` fields and constructor initialization.
  - May contain pure business calculation methods (e.g., `double get balanceDue => totalBill - advancePaid;`).
- **`repositories/`**:
  - Abstract Dart classes (interfaces) defining data contracts (e.g., `ICustomerRepository`, `IOrderRepository`).
  - Methods return `Future<Entity>`, `Future<Result<Entity>>`, or `Stream<List<Entity>>`.
  - Never import or return Isar types or Flutter widgets.

### B. Data Layer (`lib/features/<feature>/data/`)
The data layer is responsible for persistence, caching, file manipulation, and database communication.

- **`models/`**:
  - Database schema classes annotated with `@collection` or `@embedded` for Isar (e.g., `CustomerCollection`, `OrderCollection`).
  - Contain mapper extension methods:
    ```dart
    extension CustomerCollectionMapper on CustomerCollection {
      CustomerEntity toEntity() => CustomerEntity(...);
      static CustomerCollection fromEntity(CustomerEntity entity) => ...;
    }
    ```
- **`datasources/`**:
  - Local persistence classes (e.g., `CustomerLocalDataSource`) that execute direct queries, write transactions, and stream watchers on Isar.
- **`repositories/`**:
  - Concrete implementations of domain repository interfaces (e.g., `CustomerRepositoryImpl`).
  - Coordinates between datasources, maps models to entities, and returns domain-safe data.

### C. Presentation Layer (`lib/features/<feature>/presentation/`)
The presentation layer is responsible for rendering UI, reacting to state changes, and handling user gestures.

- **`providers/`**:
  - State management classes extending `ChangeNotifier`.
  - Communicate solely with repository interfaces injected via constructors.
  - Expose UI states, loading flags, and error messages.
- **`screens/`**:
  - Top-level page widgets registered in `AppRouter`.
  - Assemble dumb widgets and bind to providers.
- **`widgets/`**:
  - Reusable, modular components specific to the feature (e.g., `MeasurementGridInput`, `StatusStepper`).
  - Favor stateless widgets whenever internal animation or controller state is not required.

---

## 4. Enforcement & Static Boundaries

Any Pull Request or agent contribution violating the following rules will be rejected:

| Origin Layer | Target Layer | Allowed? | Rationale |
| :--- | :--- | :--- | :--- |
| `domain` | `flutter/*` | ❌ **FORBIDDEN** | Domain must remain pure Dart for maintainability and headless testing. |
| `domain` | `isar` | ❌ **FORBIDDEN** | Domain cannot be coupled to a specific persistence engine. |
| `presentation` | `data/models` | ❌ **FORBIDDEN** | UI must consume domain entities, not mutable Isar collections. |
| `presentation` | `data/datasources` | ❌ **FORBIDDEN** | Direct database queries bypass state management and repository caching. |
| `data` | `presentation` | ❌ **FORBIDDEN** | Reverse dependency creates circular coupling. |
| `presentation` | `domain` | ✅ **ALLOWED** | Normal clean architecture flow. |
| `data` | `domain` | ✅ **ALLOWED** | Data layer implements domain repository contracts. |
