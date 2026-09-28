# DarziDairy (Tailor Master)

**Tailor Master (Darzi Dairy)** is a standalone, offline-first mobile business tool built for independent tailors and stitching shop owners. It replaces paper measurement registers (Khata notebooks), manual chalk slips, and paper diaries (Roznamcha) with a fast, local digital workspace.

---

## Key Features

- **Customer & Measurement Khata:**
  - Fast search by name or phone digits.
  - Multi-garment measurement sheets (*Kurta Pajama*, *Shalwar Kameez*, *Two-Piece Suit*, *Waistcoat*, etc.).
  - Numeric grid entry with quick `.25"`, `.50"`, and `.75"` fraction buttons.
  - Full measurement alteration history.
- **Workshop Pipeline & Order Lifecycle:**
  - Token Tag identifier (e.g. `#B-104`) chalked onto fabric.
  - Status pipeline: `Pending` $\to$ `Cutting` $\to$ `Stitching` $\to$ `Trial Ready` $\to$ `Completed` $\to$ `Delivered`.
  - Delivery deadline countdowns and urgent job alerts.
  - Camera & gallery fabric pattern photo attachments with pinch-to-zoom inspection.
- **Financial Ledger & Roznamcha (Daily Cash Book):**
  - Live balance calculator: $\text{Stitching Rate} + \text{Add-ons} + \text{Urgent Surcharge} - \text{Advance} = \text{Balance Due}$.
  - Daily cash flow summaries (Cash In vs. Workshop Expenses).
  - Quick logger for threads, bukram, buttons, machine maintenance, and utilities.
- **100% Offline-First Architecture:**
  - High-performance local NoSQL database powered by **Isar Database**.
  - Reactive streams with `.watch()` and thread-safe singleton initialization.
  - Android 16KB page-size memory compatibility.
  - Local database export and encrypted backup management.
- **Adaptive Responsive Layout:**
  - Compact vertical phone layout (< 600dp).
  - Dual-Pane Master-Detail layout for unfolded foldables (Galaxy Z Fold, Pixel Fold) and tablets (≥ 600dp).

---

## Tech Stack

- **Framework:** Flutter & Dart
- **State Management:** Provider (`ChangeNotifier` architecture)
- **Local Database:** Isar NoSQL Database (`isar`, `isar_flutter_libs`)
- **Routing:** GoRouter (declarative deep linking and smooth page transitions)
- **Design System:** Material 3 with Craft & Tailor Light Theme (Deep Indigo & Measuring Tape Amber)

---

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/fazal-e-haq/DarziDairy.git
   cd DarziDairy
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate code (Isar Schemas):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```
