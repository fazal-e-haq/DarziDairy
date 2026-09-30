# 🧵 Darzi Dairy (Tailor Master)

> **A modern, offline-first mobile business ledger, order management, and daily expense tracking app built specifically for independent tailors, master craftsmen, and stitching workshop owners.**

---

## 📋 Table of Contents
1. [Introduction](#-introduction)
2. [What is Darzi Dairy?](#-what-is-darzi-dairy)
3. [Key Features](#-key-features)
4. [Step-by-Step Workflow Guide](#-step-by-step-workflow-guide)
   - [Tab 1: Active Orders Dashboard](#tab-1-active-orders-dashboard)
   - [Tab 2: Creating / Editing an Order](#tab-2-creating--editing-an-order)
   - [Tab 3: Order History](#tab-3-order-history)
   - [Tab 4: Workshop Profile & Expense Tracker (Roznamcha)](#tab-4-workshop-profile--expense-tracker-roznamcha)
   - [Order Details & Customer Communication](#order-details--customer-communication)
5. [Responsive Foldable & Tablet Support](#-responsive-foldable--tablet-support)
6. [Bilingual Measurement System (English + Urdu)](#-bilingual-measurement-system-english--urdu)
7. [App Architecture & Tech Stack](#-app-architecture--tech-stack)
8. [Folder & Directory Structure](#-folder--directory-structure)
9. [Getting Started & Installation](#-getting-started--installation)
10. [Database & Persistence (Isar NoSQL)](#-database--persistence-isar-nosql)
11. [Android 16KB Page Size Compatibility](#-android-16kb-page-size-compatibility)
12. [Automated Testing & Quality Verification](#-automated-testing--quality-verification)
13. [Design System & Typography](#-design-system--typography)
14. [License](#-license)

---

## 📖 Introduction

Traditional tailoring businesses rely heavily on physical paper notebooks (*Khata registers*), handwritten paper slips, and chalk marks on fabric. These manual methods frequently lead to:
- Lost or unreadable customer measurements.
- Missed customer delivery deadlines.
- Unrecorded daily workshop expenses (threads, buttons, bukram, needles, wages).
- Difficulties calculating net monthly workshop profit.
- Torn or water-damaged paper records.

**Darzi Dairy** solves these challenges by transforming your mobile phone or tablet into an intuitive, elegant digital workshop ledger that works **100% offline**, requires **zero internet access**, and ensures all records are permanently preserved even across phone reboots.

---

## 💡 What is Darzi Dairy?

Darzi Dairy is a lightweight, responsive Flutter application tailored to the daily operations of a stitching workshop:
- **Instant Search:** Find customer orders and measurements in real time by customer name or phone digits.
- **Bilingual Urdu/English Measurements:** Tailoring dimensions displayed with native Urdu terms in brackets for clarity.
- **Dedicated Daily Expense Tracker (Roznamcha):** Log workshop supplies (threads, buttons, rent, wages) and monitor real-time net profits.
- **Visual Status Recognition:** Active orders (primary blue), urgent rush jobs (soft red highlight), and completed orders (soft green highlight) are instantly recognizable.
- **100% Local NoSQL Persistence:** Built on the high-performance **Isar NoSQL Database** with reactive streams and guaranteed survival across reboots.

---

## ✨ Key Features

### 1. 📇 Customer & Order Management
- **Order Token Badges:** Auto-incremented simple order tokens (`#1`, `#2`, `#3`) for easy physical slip matching.
- **Customer Identity on Cards:** Customer Name and Phone Number are prominently displayed on every order card.
- **Garment Selection Chips:** Quick one-tap chips for *Gentlemen Suit (شلوار قمیض)*, *Kurta Pajama*, *Pant Shirt*, *Safari Suit*, *Waistcoat*, *Sherwani*, and custom garments.
- **Priority Rush Stitching:** Toggleable *Urgent* rush flag with high-visibility coral/red visual cues.
- **Delivery Date Picker:** Intuitive calendar selector with relative deadline indicators (e.g. *Due in 3 days*, *Overdue*).

### 2. 📐 Bilingual Measurement System (Inches)
- Measurement fields feature clear Urdu translations in brackets to eliminate workshop confusion:
  - **Length (لمبائی)**
  - **Chest (چھاتی)**
  - **Waist (کمر)**
  - **Hips (کولہے)**
  - **Shoulders (کندھا / تیرا)**
  - **Sleeves (بازو)**
  - **Collar (گلا / کالر)**
  - **Inseam / Shalwar Length (شلوار لمبائی)**
  - **Bottom / Daman (دامن)**
  - **Ghera (گھیرا / پائنچہ)**
- Measurements are serialized and permanently saved with each order and restored on editing.

### 3. 💸 Daily Expense Tracker & Workshop Profile (Roznamcha - روزنامچہ)
- **Financial Overview Card (حساب کتاب):**
  - **Stitching Revenue:** Live sum of all customer order rates.
  - **Workshop Expenses:** Live sum of all logged daily costs.
  - **Net Profit / Balance:** Dynamic positive/negative balance badge.
- **Predefined Workshop Categories:**
  - *Threads (دھاگہ)*, *Buttons (بٹن)*, *Bukram (بکرم)*, *Needles / Oil (سوئی / تیل)*, *Shop Rent (دکان کرایہ)*, *Electricity (بجلی بل)*, *Tea & Food (چائے / کھانا)*, *Staff Wages (اجرت / دیہاڑی)*, *Other (دیگر)*.
- **Quick Expense Entry Modal:** Add expenses in seconds with one tap.

### 4. 🧭 Polished 4-Destination Bottom Navigation Bar
- Modern Material 3 navigation bar with elevated ambient shadow and active pill indicators:
  1. **Orders (آرڈرز):** Live pipeline of pending stitching jobs.
  2. **New Order (نیا آرڈر):** Direct form to register new customers and measurements.
  3. **History (تاریخ):** Filterable archive of completed jobs.
  4. **Expenses (خرچہ / روزنامچہ):** Workshop stats, revenue, and daily expense ledger.

### 5. 📱 Foldable & Tablet Responsive Design
- Automatic adaptation to screen widths:
  - **Mobile (< 600dp):** Polished bottom navigation bar and single-column cards.
  - **Foldables & Tablets (≥ 600dp):** Side `NavigationRail` and balanced dual-column layouts.
  - **Full SafeArea Protection:** Left navigation tiles and dual-column layouts are wrapped in `SafeArea` to protect against camera cutouts, hinges, and edge bezels.

---

## 🛠 Step-by-Step Workflow Guide

### Tab 1: Active Orders Dashboard
1. Open the app to view all active stitching jobs.
2. Search instantly by typing any customer name into the search bar.
3. Each card displays:
   - Order token (`#1`).
   - Customer Name and Phone Number.
   - Garment type chip and urgent badge.
   - Price in **Rs**.
   - Delivery date with countdown or overdue indicator.

### Tab 2: Creating / Editing an Order
1. Switch to the **New Order** tab.
2. Fill in customer name, phone number, and select garment type.
3. Set the delivery deadline and urgent flag if needed.
4. Enter the stitching price (Rs).
5. Fill in the required garment measurements in the bilingual grid.
6. Tap **Save Order**. The order is instantly saved to Isar and automatically redirects to the Orders Dashboard.

### Tab 3: Order History
1. Switch to the **History** tab.
2. Completed orders are presented with soft green visual cues (`#F0FDF4`).
3. Search completed orders by customer name.

### Tab 4: Workshop Profile & Expense Tracker (Roznamcha)
1. Switch to the **Expenses** tab.
2. Inspect workshop metrics (Total Orders, Active Jobs, Completed).
3. Review your live Stitching Revenue vs. Workshop Expenses.
4. Tap **+ Add Expense** to record shop expenses with category chips and amount.
5. Tap the delete icon next to any expense item to remove it.

### Order Details & Customer Communication
1. Tap any order card on the dashboard or history.
2. Inspect customer information, delivery schedule, measurements, and payment breakdown.
3. Tap the **Copy Phone** button to instantly copy the customer's phone number to your clipboard for WhatsApp or calling.
4. Tap **Edit Order** to modify measurements or delivery dates.
5. Tap **Mark as Completed** or **Mark as Active** to move orders between pipeline stages.

---

## 🏗 App Architecture & Tech Stack

The application follows **Clean Architecture** with strict modular separation:

```
lib/
├── app.dart                                # MultiProvider and MaterialApp root
├── core/                                   # Core services, themes, constants
│   ├── constants/                          # AppColors, AppDimensions, AppStrings
│   ├── database/                           # IsarService singleton & schemas
│   ├── routing/                            # GoRouter configuration
│   ├── theme/                              # Material 3 theme & ResponsiveLayout
│   └── utils/                              # CurrencyFormatter & DateFormatter
├── features/
│   ├── expenses/                           # Daily expense tracker (Roznamcha)
│   │   ├── data/models/                    # ExpenseCollection (Isar schema)
│   │   ├── data/repositories/              # ExpenseRepository
│   │   ├── domain/entities/                # ExpenseEntity
│   │   └── presentation/
│   │       ├── providers/                  # ExpenseProvider
│   │       ├── screens/                    # ProfileExpenseScreen
│   │       └── widgets/                    # WorkshopProfileCard, FinancialOverviewCard,
│   │                                       # ExpenseListItem, AddExpenseModal
│   └── orders/                             # Order creation, dashboard, history
│       ├── data/models/                    # OrderCollection (Isar schema)
│       ├── data/repositories/              # OrderRepositoryImpl
│       ├── domain/entities/                # OrderEntity
│       └── presentation/
│           ├── providers/                  # OrderListProvider
│           └── screens/                    # OrdersDashboardScreen, CreateOrderScreen,
│                                           # OrderHistoryScreen, OrderDetailScreen
└── shared/                                 # Shared reusable UI components
    └── widgets/                            # MainShellScreen, OrderCard, MeasurementGridInput
```

### Core Dependencies:
| Library | Purpose |
|---|---|
| `flutter` | UI framework |
| `isar` & `isar_flutter_libs` | Fast, ACID-compliant local NoSQL database |
| `provider` | Reactive state management |
| `go_router` | Declarative URL-based routing |
| `intl` | Date and time formatting |

---

## 🚀 Getting Started & Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) 3.19+
- Android Studio / VS Code with Dart & Flutter extensions
- Android device or emulator (API 26+)

### Step 1: Clone Repository
```bash
git clone https://github.com/fazal-e-haq/DarziDairy.git
cd DarziDairy
```

### Step 2: Install Packages
```bash
flutter pub get
```

### Step 3: Run the App
```bash
flutter run
```

---

## 💾 Database & Persistence (Isar NoSQL)

- **100% Offline:** Operates entirely locally with zero cloud dependencies.
- **Reboot Resilience:** Data is committed safely to disk using Isar's binary storage engine. Restarting or turning off the device does not affect stored records.
- **Schema Safety:** `IsarService` uses safe initialization with directory verification to prevent crashes during app lifecycle changes.

---

## 📱 Android 16KB Page Size Compatibility

Pre-configured in `android/app/build.gradle` and `AndroidManifest.xml`:
```groovy
packagingOptions {
    jniLibs {
        useLegacyPackaging = true
    }
}
```
Ensures 100% compatibility with Android 15+ (API 35) 16KB page-size requirements.

---

## 🧪 Automated Testing & Quality Verification

Run the comprehensive automated test suite with:
```bash
flutter test
```

### Test Suite Highlights (17 Tests):
- **`expense_tracker_test.dart`:** Tests expense creation, total sums, and deletion.
- **`isar_database_test.dart`:** Tests singleton safety, persistence, and state transitions.
- **`order_history_test.dart`:** Tests 4-destination shell, history navigation, card styling (red/green), customer validation, and Urdu measurement labels.
- **`widget_test.dart`:** Smoke tests app bootstrapping and dashboard loading.

### Code Quality Check:
```bash
flutter analyze
```
*Current status: 0 errors, 0 warnings.*

---

## 🎨 Design System & Typography

- **Primary Color:** Tailor Blue (`#1E3A8A`)
- **Secondary Color:** Measuring Amber (`#D97706`)
- **Urgent Accent:** Soft Coral (`#FEF2F2` bg, `#DC2626` text)
- **Completed Accent:** Soft Mint (`#F0FDF4` bg, `#16A34A` text)
- **Typography:**
  - Headings: `Nunito` (rounded, bold)
  - Body: `Poppins` (clean, readable)

---

*Crafted with ❤️ for tailors, master craftsmen, and stitching workshops.*
