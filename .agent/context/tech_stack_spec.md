# Technology Stack Specifications

## 1. Runtime Environment & Toolchain Constraints

| Component | Target Version / Constraint | Rationale |
| :--- | :--- | :--- |
| **Dart SDK** | `^3.3.0` | Enables pattern matching, records, class modifiers, and super parameters. |
| **Flutter SDK** | `>=3.19.0` | Material 3 stabilization, enhanced Impeller rendering engine, Android 15 compatibility. |
| **Target OS (Android)** | API 21 (Lollipop) to API 35 (Android 15) | Supports 99% of bazaar tailoring devices while remaining 16KB page-size compliant. |
| **Target OS (iOS)** | iOS 12.0+ | Supports legacy iPad / iPhone devices used at boutique counters. |

---

## 2. Production Dependencies & Rationale

```yaml
dependencies:
  flutter:
    sdk: flutter

  # UI & Design System
  cupertino_icons: ^1.0.8

  # State Management
  provider: ^6.1.2 # Clean ChangeNotifier architecture, zero boilerplate, reactive selectors

  # Local NoSQL Database
  isar: ^3.1.0+1 # High-speed embedded database, multi-isolate read, zero JSON overhead
  isar_flutter_libs: ^3.1.0+1 # Precompiled C++ binaries for ARM, ARM64, x86_64

  # Local Storage & Sandboxing
  path_provider: ^2.1.2 # Access to getApplicationDocumentsDirectory()
  path: ^1.9.0 # File path manipulation and anti-traversal normalization

  # Security & Key Management
  flutter_secure_storage: ^9.0.0 # Hardware Keystore / Keychain for database encryption key
  crypto: ^3.0.3 # SHA-256 integrity checksum calculation for backup validation

  # Localization, Formatting, & Math
  intl: ^0.19.0 # Date formatting, currency symbols, and numbers

  # Document Generation & WhatsApp Sharing
  pdf: ^3.10.8 # Headless vector PDF generation for offline customer receipts
  printing: ^5.11.1 # Direct thermal receipt printer connectivity (Bluetooth/ESC-POS)
  share_plus: ^9.0.0 # Dispatches offline WhatsApp/SMS receipt text and PDF file intents

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0 # Enforces strict Dart style conventions
  build_runner: ^2.4.9 # Code generation engine for Isar schemas
  isar_generator: ^3.1.0+1 # Generates Isar collection accessors and type adapters
```

---

## 3. Platform Configurations

### Android (`android/app/build.gradle`):
```groovy
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        
        ndk {
            abiFilters "armeabi-v7a", "arm64-v8a", "x86_64"
        }
    }

    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Proguard Rules (`android/app/proguard-rules.pro`):
```proguard
# Preserve Isar Native Engine and Generated Collections
-keep class com.isar.** { *; }
-keepclassmembers class * {
    @com.isar.annotation.* <fields>;
    @com.isar.annotation.* <methods>;
}
-dontwarn com.isar.**
```

### iOS (`ios/Podfile`):
```ruby
platform :ios, '12.0'
use_frameworks!
```

---

## 4. Hardware Optimization Policies

1. **Memory Budget:** App resident memory must not exceed **85MB** during active image capture or receipt printing.
2. **Cold Launch Target:** Must achieve interactive frame in less than **800ms** on mid-range Android hardware.
3. **Database Concurrency:** All bulk reads run on background isolates using `isar.writeTxn()` and `findAllAsync()`.
