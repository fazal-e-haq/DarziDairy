# Provider Conventions & State Management Guidelines

## 1. Responsibilities
- Providers (`ChangeNotifier`) manage UI state, form validation, and reactive streams from repositories.
- **Zero UI Logic in Providers:** Never store `BuildContext`, `Color`, or `Widget` references inside a Provider.
- Keep providers focused and single-purpose (e.g., `CustomerListProvider` vs `CustomerFormProvider`).

## 2. Reactive Streams
- Utilize Isar's reactive queries (`collection.watchLazy()`) inside repository implementations and bridge them via Providers.
- Safely manage subscriptions and always call `dispose()` or cancel streams when providers or views are destroyed.

## 3. State Mutation Rules
- Set state, validate inputs, notify listeners with `notifyListeners()`.
- Use loading/error status indicators (`isLoading`, `errorMessage`) to allow UI widgets to show spinners or snackbars predictably.
