# Flutter Provider & State Management Rules

## 1. Zero Business Logic in UI `build()` Methods
The `build()` method in Flutter widgets must remain purely declarative.

### Strict Prohibitions:
- **No Math or Financial Calculations in `build()`:**
  - ❌ `final balance = order.rate + order.fabricCost - order.advance;`
  - ✅ `final balance = order.balanceDue;` (Computed on the immutable `OrderEntity` or calculated in Provider).
- **No Date Math or Complex String Formatting:**
  - ❌ Re-parsing dates or filtering list iterables inside `build()`.
  - ✅ Delegate to `DateFormatter` utility or expose pre-filtered lists from the Provider.
- **No Direct Async Calls in `build()`:**
  - ❌ `Provider.of<CustomerProvider>(context).fetchCustomers();` inside `build()`.
  - ✅ Trigger initialization in `initState()` via `microtask` or `addPostFrameCallback`.

---

## 2. Granular Rebuild Optimizations (`context.select` & `Consumer`)

Uncontrolled `context.watch<T>()` or `Provider.of<T>(context)` at the top of a large widget tree causes cascading, expensive re-renders across all child widgets whenever any property updates.

### Mandatory Rules:
1. **Targeted Subscriptions with `context.select<T, R>()`:**
   When a widget only cares about a single field or scalar value, subscribe exclusively to that field:
   ```dart
   // ✅ GOOD: Rebuilds ONLY when customerName changes
   final customerName = context.select<CustomerDetailProvider, String>(
     (p) => p.customer.name,
   );
   ```
2. **Isolate Dynamic Sections with `Consumer` / `Selector`:**
   Wrap only the subtree that depends on the changing state:
   ```dart
   // ✅ GOOD: Heavy screen scaffold does not rebuild when counter increments
   Selector<OrderListProvider, int>(
     selector: (_, provider) => provider.urgentOrdersCount,
     builder: (context, urgentCount, child) {
       return Badge(count: urgentCount, child: child);
     },
     child: const Icon(Icons.warning), // static child remains cached
   )
   ```
3. **Never call `watch` inside event handlers:**
   - ❌ `onPressed: () => context.watch<OrderFormProvider>().save()`
   - ✅ `onPressed: () => context.read<OrderFormProvider>().save()`

---

## 3. Strict Memory Leak Prevention & Lifecycle Guards

Because tailoring apps run continuously on shop devices with dirty screens and prolonged foreground sessions, unclosed resources will exhaust device RAM.

### Mandatory Resource Disposal Checklist:
1. **Controllers & FocusNodes:**
   Every `TextEditingController`, `ScrollController`, `TabController`, and `FocusNode` instantiated in a `StatefulWidget` MUST be released in `dispose()`:
   ```dart
   @override
   void dispose() {
     _tokenController.dispose();
     _phoneController.dispose();
     _searchFocusNode.dispose();
     super.dispose();
   }
   ```
2. **Stream Subscriptions & Watchers:**
   Any stream subscription from an Isar watcher or reactive stream inside a `ChangeNotifier` must be explicitly cancelled when the provider is disposed:
   ```dart
   class OrderListProvider extends ChangeNotifier {
     StreamSubscription<List<OrderCollection>>? _orderWatcherSub;

     void initializeWatcher() {
       _orderWatcherSub = repository.watchActiveOrders().listen((orders) {
         _orders = orders;
         notifyListeners();
       });
     }

     @override
     void dispose() {
       _orderWatcherSub?.cancel();
       super.dispose();
     }
   }
   ```
3. **Guard `notifyListeners()` Against Disposed Providers:**
   Never call `notifyListeners()` after an async gap without validating if the provider is still mounted/active:
   ```dart
   Future<void> submit() async {
     _isSaving = true;
     notifyListeners();

     try {
       await repository.save(entity);
     } finally {
       if (hasListeners) {
         _isSaving = false;
         notifyListeners();
       }
     }
   }
   ```
