# Isar Database Rules & Performance Optimization

## 1. High-Frequency Indexing Policy
Isar is an ultra-fast NoSQL database, but sequential table scans on unindexed collections degrade frame rates when customer accounts exceed thousands of records.

### Mandatory `@Index` Annotations:

| Collection | Field Name | Index Type | Rationale |
| :--- | :--- | :--- | :--- |
| `CustomerCollection` | `phone` | `@Index(type: IndexType.hash)` | Exact phone number lookup during incoming calls/walk-ins. |
| `CustomerCollection` | `name` | `@Index(type: IndexType.value, caseSensitive: false)` | Prefix and case-insensitive search in customer directory. |
| `OrderCollection` | `orderToken` | `@Index(type: IndexType.hash)` | Instant search by chalk tag (e.g. `#B-104`). |
| `OrderCollection` | `targetDeadline` | `@Index()` | Urgent sorting on workshop dashboard. |
| `OrderCollection` | `status` | `@Index()` | Workshop pipeline stage filtering (`Cutting`, `Stitching`). |
| `OrderCollection` | `isDeleted` | `@Index()` | Excludes soft-deleted items from main views without scans. |
| `ExpenseCollection` | `expenseDate` | `@Index()` | Daily ledger aggregation in Roznamcha. |

```dart
@collection
class OrderCollection {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.hash)
  late String orderToken;

  @Index()
  late DateTime targetDeadline;

  @Index()
  late int status;

  @Index()
  late bool isDeleted;
}
```

---

## 2. Reactive Watchers (`watchLazy` & `watchObject`)

Never poll the database on timers or manually refresh screens after write transactions. Use Isar's native C++ reactive watchers.

### Pattern for Watchers:
- **`watchLazy()` for List Reactivity:**
  Triggers a notification whenever *any* item in the collection matching query criteria changes, without paying the cost of serializing objects if not immediately needed.
  ```dart
  Stream<List<OrderCollection>> watchActiveOrders() {
    return isar.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .sortByTargetDeadline()
        .watch(fireImmediately: true);
  }
  ```
- **`watchObject()` for Single Item Reactivity:**
  Used inside `OrderDetailProvider` or `CustomerDetailProvider` to observe changes to a single document without rebuilding other UI components.

---

## 3. Android 16KB Page-Size Architecture Compliance

Android 15 and modern ARM64 kernels introduce support for 4KB and 16KB physical memory page sizes. Traditional native binaries compiled strictly for 4KB page alignment will crash (`SIGSEGV` or `dlopen failed: unaligned segment`) on 16KB devices.

### Mandatory Compliance Rules:
1. **Engine Alignment:** Ensure `isar_flutter_libs` uses binary builds configured with `-Wl,-z,max-page-size=16384` ELF alignment.
2. **Packaging Verification:** When compiling release APKs/Bundles, verify that shared object libraries (`libisar.so`) have 16KB ELF alignment:
   ```bash
   # Run alignment verification on unpacked .so:
   objdump -p libisar.so | grep LOAD
   ```
3. **Graceful Fallback:** If Isar dynamic library fails to load on legacy or custom ROMs, fail explicitly with a user-visible `DatabaseFailure` dialog rather than causing an unhandled native crash.

---

## 4. Binary Media & Sandbox Path Isolation

### Absolute Rule: Never Store Raw Image Bytes in Isar
- Storing high-resolution camera images (`Uint8List` / base64) directly inside Isar documents leads to:
  - Severe DB file fragmentation.
  - Native heap memory spikes exceeding OS limits on low-end phones (2GB RAM).
  - Slow cursor loading times for entire collections.

### Correct Implementation:
1. Persist captured fabric images or sketches directly to disk in `getApplicationDocumentsDirectory()`.
2. Store **only relative file paths** in `OrderCollection.fabricImagePaths`:
   ```dart
   // ✅ CORRECT:
   @collection
   class OrderCollection {
     Id id = Isar.autoIncrement;
     List<String> fabricImagePaths = []; // e.g., ["fabrics/order_104_1.jpg"]
   }
   ```
3. Reconstruct absolute file paths dynamically at runtime using `FileStorageHelper`.
