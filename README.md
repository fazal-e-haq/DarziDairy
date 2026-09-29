# 🧵 Darzi Dairy (Tailor Master)

> **A modern, offline-first mobile business ledger and order management app built specifically for independent tailors, fashion designers, and stitching workshop owners.**

---

## 📋 Table of Contents
1. [Introduction](#-introduction)
2. [What is Darzi Dairy?](#-what-is-darzi-dairy)
3. [Key Features](#-key-features)
4. [Step-by-Step Workflow Guide](#-step-by-step-workflow-guide)
   - [Step 1: Dashboard & Active Orders](#step-1-dashboard--active-orders)
   - [Step 2: Creating a New Order](#step-2-creating-a-new-order)
   - [Step 3: Searching & Filtering Orders](#step-3-searching--filtering-orders)
   - [Step 4: Completing Orders & History](#step-4-completing-orders--history)
   - [Step 5: Order Details & Customer Contact](#step-5-order-details--customer-contact)
   - [Step 6: Settings & Workshop Configuration](#step-6-settings--workshop-configuration)
5. [App Architecture & Tech Stack](#-app-architecture--tech-stack)
6. [Folder & Directory Structure](#-folder--directory-structure)
7. [Getting Started & Installation](#-getting-started--installation)
8. [Database & Persistence (Isar NoSQL)](#-database--persistence-isar-nosql)
9. [Android 16KB Page Size Compatibility](#-android-16kb-page-size-compatibility)
10. [Automated Testing & Quality Verification](#-automated-testing--quality-verification)
11. [Design System & Typography](#-design-system--typography)
12. [License](#-license)

---

## 📖 Introduction

Traditional tailoring businesses rely heavily on physical paper notebooks (*Khata registers*), handwritten paper slips, and manual chalk marks on cloth. These methods often lead to:
- Lost customer measurements.
- Missed delivery deadlines.
- Difficulties tracking paid amounts and pending orders.
- Torn or water-damaged paper records.

**Darzi Dairy** eliminates these problems by converting your smartphone into a digital workshop diary that works **100% offline**, requires **zero internet connection**, and ensures your data is permanently preserved even if you restart your phone.

---

## 💡 What is Darzi Dairy?

Darzi Dairy is a lightweight, responsive Flutter application tailored to the day-to-day workflow of a tailoring shop:
- **Instant Record Retrieval:** Find any customer's measurements by typing their name or phone number.
- **Customized Garment Templates:** Pre-configured measurement slots for traditional and modern garments (*Shalwar Kameez*, *Kurta*, *Pant Shirt*, *Coat*, *Waistcoat*, *Sherwani*, etc.).
- **Visual Status Cues:** Active orders, urgent priority jobs (soft red highlight), and completed orders (soft green highlight) are distinguished at a glance.
- **Local Data Guarantee:** All customer data, order details, and measurements are stored on-device using the high-performance **Isar NoSQL Database**.

---

## ✨ Key Features

### 1. 📇 Customer & Order Management
- **Required Customer Information:** Strict validation on Customer Name and Phone Number to prevent orphaned or incomplete orders.
- **Garment Type Selector:** One-tap selection chips for common garment categories.
- **Urgent Job Indicator:** Interactive urgent checkbox with check icon to highlight rush jobs.
- **Delivery Date Picker:** Intuitive calendar selector with formatted date displays.

### 2. 💰 Simplified Pricing in Rupees (Rs)
- Clean, focused payment field displaying the currency as **Rs**.
- Eliminates unnecessary accounting clutter while ensuring the stitching price is tracked accurately.

### 3. 📐 Measurement Grid (Inches)
- Dedicated 2-column numeric input grid for all major tailoring dimensions:
  - *Length, Chest, Waist, Hips, Shoulders, Sleeves, Collar, Inseam, Bottom / Daman*.
- Simple, clear inputs tailored for workshop tape-measure values.

### 4. 📊 Dashboard & Order Pipeline
- **Real-Time Counters:** Header cards showing counts for *Active*, *Urgent*, and *Completed* orders.
- **Live Search Bar:** Instant debounced search filtering by customer name or phone digits.
- **Actionable Cards:** Tap to inspect order, swipe or tap to mark completed, and delete with confirmation.

### 5. 📜 Dedicated Order History
- Easily accessible via the **History Icon** in the top AppBar.
- Displays completed orders with a calming **soft green background and border** (`#F0FDF4`).
- Shows total completed order count and date of completion.

### 6. ⚙️ Clean Settings Screen
- Dedicated page accessible via the **Settings Icon** in the top AppBar.
- Ready for future workshop personalization, profile customization, and data backup tools.

---

## 🛠 Step-by-Step Workflow Guide

### Step 1: Dashboard & Active Orders
1. Open the application. The **Orders Dashboard** displays all active stitching jobs.
2. The top bar contains:
   - App title: **Tailor Master**.
   - **History Button (Clock Icon):** Opens completed orders.
   - **Settings Button (Gear Icon):** Opens workshop settings.
3. Summary cards show live counts for:
   - **Total Active Orders**
   - **Urgent Orders Pending**
   - **Completed Orders**
4. Each order card shows:
   - Customer name and phone number.
   - Garment type (e.g., *Shalwar Kameez*).
   - Delivery date.
   - Price in **Rs**.
   - **Urgent Badge & Red Tint** (if marked urgent).
   - **Mark Complete Button (Checkmark icon):** Instantly archives the order.

### Step 2: Creating a New Order
1. Tap the **+ (Plus) Floating Action Button** at the bottom-right of the dashboard.
2. **Customer Details:**
   - Enter **Customer Name** *(Required)*.
   - Enter **Phone Number** *(Required)*.
3. **Garment & Delivery:**
   - Tap one of the garment category chips (*Shalwar Kameez*, *Kurta*, *Pant Shirt*, *Coat*, etc.).
   - Tap the **Delivery Date** card to pick the target completion date from the calendar.
   - Tap the **Urgent** checkbox if this order requires priority rush stitching.
4. **Payment Price:**
   - Enter the stitching price in the payment field (prefixed with **Rs**).
5. **Measurements (Inches):**
   - Fill in the required tape measurements in the grid fields (*Length*, *Chest*, *Waist*, *Sleeves*, *Collar*, etc.).
6. Tap **Save Order**. The order is immediately saved to the local Isar database and appears on your dashboard.

### Step 3: Searching & Filtering Orders
1. On the dashboard, tap the search bar at the top.
2. Type any part of a customer's name (e.g., `"Ahmed"`) or phone digits (e.g., `"0300"`).
3. The list updates instantly in real time to show only matching orders.
4. Clear the search bar to restore the full list.

### Step 4: Completing Orders & History
1. Once a garment has been stitched, tap the green **Checkmark Icon** on the order card.
2. The order is automatically updated to `Status: Completed`.
3. It moves out of the active list and into the **Order History** screen.
4. Tap the **History Icon** in the top AppBar to view all finished orders.
5. In History, completed orders are highlighted with a **soft green tint and border** to provide clear visual feedback.

### Step 5: Order Details & Customer Contact
1. Tap anywhere on an order card to open the **Order Detail Screen**.
2. From this screen you can:
   - View complete garment specifications and delivery timeline.
   - Check the urgent status badge.
   - Directly **Call** or **WhatsApp** the customer with one tap.
   - Inspect the complete measurements grid.
   - **Edit Order:** Change measurements, price, or delivery date.
   - **Delete Order:** Safely remove the record with a confirmation dialog.

### Step 6: Settings & Workshop Configuration
1. Tap the **Gear Icon** in the top AppBar.
2. The Settings screen displays app details, local database status, and ready-to-expand workshop configuration options.

---

## 🏗 App Architecture & Tech Stack

The application follows **Clean Architecture** principles separated into feature modules:

```
lib/
├── core/                  # Core infrastructure, themes, constants, and database
├── features/              # Feature-driven business logic and screens
│   ├── orders/            # Order creation, dashboard, history, and details
│   └── settings/          # Workshop settings and configuration
└── shared/                # Reusable cross-feature UI widgets
```

### Core Technologies:
| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter 3.x (Dart 3.x) | High-performance, cross-platform UI framework |
| **Database** | Isar Database (`isar`, `isar_flutter_libs`) | Fast, ACID-compliant local NoSQL database with reactive queries |
| **State Management** | Provider (`ChangeNotifier`) | Reactive, testable state management without boilerplate |
| **Routing** | GoRouter | Declarative routing with deep linking support |
| **Design System** | Material 3 | Modern design language customized for tailoring workshops |
| **Typography** | Nunito (Headings) & Poppins (Body) | Highly readable fonts loaded locally |

---

## 📁 Folder & Directory Structure

```
darzi_dairy/
├── android/                        # Native Android project configuration
│   └── app/
│       ├── build.gradle            # 16KB page-size & legacy packaging flags
│       └── src/main/AndroidManifest.xml
├── assets/
│   ├── fonts/                      # Offline bundled fonts (Nunito, Poppins)
│   └── images/                     # App logo and branding assets
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart     # Primary, secondary, status, and card colors
│   │   │   ├── app_dimensions.dart # Standard 8-point spacing and radius scales
│   │   │   └── app_strings.dart    # Garment names and UI string constants
│   │   ├── database/
│   │   │   └── isar_service.dart   # Thread-safe Isar singleton and schema manager
│   │   ├── theme/
│   │   │   └── app_theme.dart      # Material 3 theme and TextTheme extensions
│   │   └── utils/
│   │       └── date_formatter.dart # Date formatting helpers (e.g., 29 Sep 2026)
│   ├── features/
│   │   ├── orders/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── order_model.dart       # Isar collection schema
│   │   │   │   │   └── order_model.g.dart     # Auto-generated Isar code
│   │   │   │   └── repositories/
│   │   │   │       └── order_repository.dart  # Data access layer
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── order_provider.dart    # Business logic & reactive state
│   │   │       └── screens/
│   │   │           ├── create_order_screen.dart     # Order entry form
│   │   │           ├── order_detail_screen.dart     # Full order view & actions
│   │   │           ├── order_history_screen.dart    # Completed orders screen
│   │   │           └── orders_dashboard_screen.dart # Main workshop screen
│   │   └── settings/
│   │       └── presentation/
│   │           └── screens/
│   │               └── settings_screen.dart   # Workshop settings screen
│   ├── shared/
│   │   └── widgets/
│   │       ├── custom_button.dart             # Primary and secondary buttons
│   │       ├── custom_text_field.dart         # Form inputs with 'Rs' prefix
│   │       ├── measurement_grid_input.dart    # 2-column measurement entry
│   │       └── order_card.dart                # Visual card with status tinting
│   ├── app_router.dart                        # Route definitions
│   └── main.dart                              # App entry point with Isar initialization
├── test/
│   ├── isar_database_test.dart                # Database safety & schema test
│   └── order_history_test.dart                # UI, validation & history tests
├── pubspec.yaml                               # Dependencies and asset declarations
└── README.md                                  # Complete project documentation
```

---

## 🚀 Getting Started & Installation

### Prerequisites
Before running the project, make sure you have installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.19 or later recommended).
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter).
- Android Studio / VS Code with Flutter and Dart extensions.
- An Android device or emulator running API 26+.

### Step 1: Clone the Repository
```bash
git clone https://github.com/fazal-e-haq/DarziDairy.git
cd DarziDairy
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Generate Database Schemas (Build Runner)
The project uses Isar code generation for type-safe database queries. If you modify `order_model.dart`, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4: Run the Application
Connect your physical device or start an emulator, then execute:
```bash
flutter run
```

---

## 💾 Database & Persistence (Isar NoSQL)

Darzi Dairy is designed with **zero reliance on cloud servers or internet access**:
1. **Local File Storage:** Data is stored directly in the device's application documents directory using Isar's binary format.
2. **Persistence Guarantee:** When the phone is turned off, restarted, or the app is killed from recent tasks, all orders, prices, and measurements remain fully intact.
3. **Reactive Query Streams:** Any change made (insert, update, delete) immediately notifies the UI through `order_provider.dart`, keeping the dashboard in sync.
4. **Safe Initialization:** The `IsarService` singleton features automatic fallback directory detection and error handling to ensure the app never crashes on startup.

---

## 📱 Android 16KB Page Size Compatibility

Modern Android versions (Android 15+ / API 35) require native C/C++ libraries (such as `libisar.so`) to be compatible with 16KB memory page sizes. 

Darzi Dairy is pre-configured for full production stability on all devices:
- In `android/app/build.gradle`:
  ```groovy
  packagingOptions {
      jniLibs {
          useLegacyPackaging = true
      }
  }
  ```
- In `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <application
      android:extractNativeLibs="true"
      ... >
  ```
This prevents Android 15 page-size warnings and ensures native libraries are unpacked cleanly at install time.

---

## 🧪 Automated Testing & Quality Verification

The project includes unit, widget, and integration tests to maintain high code quality.

### Running Tests
Execute the automated test suite with:
```bash
flutter test
```

### Test Coverage Highlights:
- **`isar_database_test.dart`**:
  - Tests singleton initialization and safe error handling without crashing.
  - Validates Isar collection schemas.
- **`order_history_test.dart`**:
  - Verifies AppBar displays History and Settings icons.
  - Verifies navigation to Order History and Settings.
  - Tests OrderCard soft green tint (`#F0FDF4`) for completed orders.
  - Tests OrderCard soft red tint (`#FEF2F2`) for urgent orders.
  - Tests required field validation on Customer Name and Phone Number.
  - Confirms removal of deprecated fraction toolbars.

### Code Analysis
Ensure zero lint or syntax warnings:
```bash
flutter analyze
```

---

## 🎨 Design System & Typography

The visual style is crafted specifically for tailoring workshop clarity:
- **Primary Color:** Tailor Blue (`#1E3A8A`) — professional, clean, and trustworthy.
- **Secondary Color:** Measuring Amber (`#D97706`) — inspired by traditional tailoring measuring tapes.
- **Urgent Highlight:** Soft Coral/Red (`#FEF2F2` background, `#DC2626` border/text).
- **Completed Highlight:** Soft Mint/Green (`#F0FDF4` background, `#16A34A` border/text).
- **Typography:**
  - **Headings:** `Nunito` (bold, readable, rounded numbers).
  - **Body & Captions:** `Poppins` (modern, legible on all screen sizes).
  - Accessible directly through `Theme.of(context).textTheme.heading` and `Theme.of(context).textTheme.body`.

---

## 📄 License

This project is licensed under the MIT License. Feel free to use, modify, and distribute according to the license terms.

---

*Crafted with ❤️ for tailors, master craftsmen, and stitching workshops.*
