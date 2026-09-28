# Isar Database Schema & Indexes

Tailor Master uses **Isar NoSQL Database** for local storage, multi-isolate read capabilities, fast indexed search, and reactive streams.

---

## 1. `CustomerCollection` (`@collection`)
Represents customer contact details and measurement links.

| Field | Type | Modifiers / Notes |
| :--- | :--- | :--- |
| `id` | `Id` | `Isar.autoIncrement` |
| `customerId` | `String` | Indexed (unique identifier e.g., `CUST-1001`) |
| `name` | `String` | `@Index(type: IndexType.value, caseSensitive: false)` for quick fuzzy/prefix search |
| `phone` | `String` | `@Index(type: IndexType.hash)` for exact phone lookup |
| `secondaryPhone`| `String?` | Optional alternate contact |
| `notes` | `String?` | Custom customer preferences or address |
| `createdAt` | `DateTime` | Timestamp of registration |
| `updatedAt` | `DateTime` | Last profile update timestamp |
| `measurements` | `List<MeasurementItem>` | Embedded list of garment measurement profiles |

---

## 2. `MeasurementItem` (`@embedded`)
Stored within `CustomerCollection` or linked to an order. Represents garment dimensions and historic sizing.

| Field | Type | Description |
| :--- | :--- | :--- |
| `garmentType` | `String` | E.g., `Kurta Pajama`, `Shalwar Kameez`, `Pant/Shirt`, `Waistcoat` |
| `title` | `String` | E.g., "Regular Fit", "Festive Eid Fit" |
| `values` | `List<MeasurementValue>` | Key-value pairs (`length`, `chest`, `waist`, `hip`, `shoulder`, `sleeve`, `neck`, `inseam`, `pancha`) |
| `updatedAt` | `DateTime` | Alteration / capture date |

---

## 3. `OrderCollection` (`@collection`)
Represents a tailoring job order and workshop status pipeline.

| Field | Type | Modifiers / Notes |
| :--- | :--- | :--- |
| `id` | `Id` | `Isar.autoIncrement` |
| `orderToken` | `String` | `@Index(type: IndexType.hash)` Chalk token (e.g., `#B-104`, `#A-12`) |
| `customerId` | `Id` | Links to `CustomerCollection` |
| `customerName` | `String` | Denormalized for rapid list rendering |
| `customerPhone`| `String` | Denormalized for fast receipt generation / WhatsApp |
| `garmentType` | `String` | Garment type for the order |
| `measurements` | `List<MeasurementValue>` | Snapshot of measurements at time of booking |
| `styleOptions` | `List<StyleOption>` | Collar (`Ban`, `Sherwani`, `Spread`), Cuffs, Pocket count |
| `fabricImagePaths`| `List<String>` | Relative local file paths to fabric/sketch photos |
| `bookingDate` | `DateTime` | Date order was placed |
| `targetDeadline`| `DateTime` | `@Index()` Delivery due date (for sorting urgency) |
| `isUrgent` | `bool` | Urgent priority flag |
| `status` | `int` | Enum as int: `0: Pending`, `1: Cutting`, `2: Stitching`, `3: TrialReady`, `4: Completed`, `5: Delivered` |
| `stitchingRate`| `double` | Base tailoring charge |
| `fabricCharges`| `double` | Material / add-on charges |
| `urgentSurcharge`| `double` | Extra fee for fast-track delivery |
| `advancePaid` | `double` | Down payment paid at booking |
| `balanceDue` | `double` | Auto-calculated: `(stitchingRate + fabricCharges + urgentSurcharge) - advancePaid` |
| `isDeleted` | `bool` | `@Index()` Soft-deletion flag for recycle bin |
| `deletedAt` | `DateTime?` | Timestamp of soft-deletion |

---

## 4. `ExpenseCollection` (`@collection`)
Daily shop expense entries for the Roznamcha ledger.

| Field | Type | Modifiers / Notes |
| :--- | :--- | :--- |
| `id` | `Id` | `Isar.autoIncrement` |
| `category` | `String` | Threads, Buttons, Bukram, Machine Oil, Utility, Rent, Tea/Food, Other |
| `amount` | `double` | Expense amount |
| `note` | `String?` | Optional description |
| `expenseDate` | `DateTime` | `@Index()` Date of expense for daily ledger aggregation |
| `createdAt` | `DateTime` | Timestamp of logging |
