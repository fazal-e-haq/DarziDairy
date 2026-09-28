# Skill: Release Readiness Audit

## Description
This skill provides a comprehensive, automated quality assurance and security audit designed for Tailor Master prior to generating production APK, AAB, or iOS IPA artifacts.

---

## Audit Execution Stages

### Stage 1: Static Code Analysis & Layer Contracts
Execute Flutter strict analysis to confirm zero lints, unused imports, or layer boundary breaches:
```bash
flutter analyze --fatal-infos
```
**Verification Criterion:** `No issues found!` must be returned.

### Stage 2: Architecture Boundary Violations Scan
Search for forbidden cross-layer imports using automated shell pattern scans:
```bash
# Verify Domain Layer has zero Flutter or Isar imports
powershell -Command "Select-String -Path 'lib\features\*\domain\*.dart' -Pattern 'package:flutter', 'package:isar', 'package:provider'"

# Verify Presentation Layer does not import Data Layer directly
powershell -Command "Select-String -Path 'lib\features\*\presentation\*.dart' -Pattern '/data/datasources', '/data/models'"
```
**Verification Criterion:** Command output must be completely empty.

### Stage 3: Offline Air-Gap & Telemetry Scan
Scan the entire codebase to guarantee zero telemetry, tracking SDKs, or unauthorized HTTP network calls:
```bash
powershell -Command "Select-String -Path 'lib\*.dart', 'lib\**\*.dart' -Pattern 'http.get', 'http.post', 'Dio(', 'Firebase', 'Analytics', 'Crashlytics'"
```
**Verification Criterion:** Zero matches outside allowed local file-sharing intents.

### Stage 4: Android 16KB Page-Size Alignment Audit
On modern ARM64 Android devices (Android 15+), native shared objects (`.so`) must be aligned to 16KB boundaries to prevent fatal system crashes.

1. Build Android APK:
   ```bash
   flutter build apk --release --target-platform android-arm64
   ```
2. Unpack APK and verify `libisar.so` page alignment using `llvm-objdump` or `readelf`:
   ```bash
   # Check ELF segment alignment:
   readelf -l build/app/intermediates/merged_native_libs/release/out/lib/arm64-v8a/libisar.so | grep -A 1 LOAD
   ```
   **Verification Criterion:** `Align` column for all LOAD segments must be `0x4000` (16384 bytes) or greater.

### Stage 5: Database Index & Query Health Audit
Verify that all search and filter fields in Isar schemas are indexed:
- [ ] `CustomerCollection.phone` has `@Index(type: IndexType.hash)`
- [ ] `CustomerCollection.name` has `@Index(type: IndexType.value, caseSensitive: false)`
- [ ] `OrderCollection.orderToken` has `@Index(type: IndexType.hash)`
- [ ] `OrderCollection.targetDeadline` has `@Index()`
- [ ] `OrderCollection.status` has `@Index()`
- [ ] `OrderCollection.isDeleted` has `@Index()`
- [ ] `ExpenseCollection.expenseDate` has `@Index()`

### Stage 6: Backup / Restore Integrity Smoke Test
1. Export a sample Khata backup file.
2. Verify that a SHA-256 digest is generated and recorded.
3. Simulate file tampering (modify 1 byte).
4. Verify that the app's restore mechanism rejects the tampered archive with a `BackupFailure`.
5. Restore original backup and verify full record count consistency.

### Stage 7: Automated Test Suite Execution
Execute all unit and widget tests:
```bash
flutter test --coverage
```
**Verification Criterion:** 100% test pass rate.
