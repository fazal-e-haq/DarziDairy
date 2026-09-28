# Offline Security & Data Protection Rules (OWASP MASVS Aligned)

## 1. Local Database Encryption & Key Management
Tailor Master handles sensitive personal customer information (phone numbers, addresses, custom fit measurements).

### Security Requirements:
1. **AES-256 Database Encryption:**
   - When supported, Isar database instances must be opened using a 256-bit cryptographic key.
2. **Hardware-Backed Keystore:**
   - The master key must never be hardcoded, logged, or stored in plaintext `SharedPreferences` / `NSUserDefaults`.
   - Store and retrieve the key using `flutter_secure_storage` which utilizes Android Keystore and iOS Keychain Services:
     ```dart
     import 'dart:convert';
     import 'dart:math';
     import 'package:flutter_secure_storage/flutter_secure_storage.dart';

     class KeyManager {
       static const _keyName = 'isar_master_key';
       static const _storage = FlutterSecureStorage(
         aOptions: AndroidOptions(encryptedSharedPreferences: true),
       );

       static Future<String> getOrCreateEncryptionKey() async {
         String? key = await _storage.read(key: _keyName);
         if (key == null) {
           final random = Random.secure();
           final values = List<int>.generate(32, (i) => random.nextInt(256));
           key = base64UrlEncode(values);
           await _storage.write(key: _keyName, value: key);
         }
         return key;
       }
     }
     ```

---

## 2. File Path Sandboxing & Directory Isolation

Tailor Master captures customer fabric images and generates PDF measurement slips.

### Strict Sandbox Rules:
1. **Confine to Application Documents Directory:**
   - All assets MUST reside within `getApplicationDocumentsDirectory()`.
   - Never write to world-readable public directories (`/sdcard/Download`, `/tmp`) without explicit user export actions.
2. **Path Traversal Protection:**
   - Never accept unvalidated relative file paths from external sources. Prevent directory traversal attacks (`../` or `..\\`) when loading or saving files:
     ```dart
     String sanitizeRelativePath(String input) {
       final normalized = p.normalize(input);
       if (normalized.startsWith('..') || p.isAbsolute(normalized)) {
         throw SecurityException('Path traversal detected in file path: $input');
       }
       return normalized;
     }
     ```

---

## 3. Cryptographic Backup Validation (SHA-256 Checksums)

Offline backups are stored as files on external SD cards or shared via WhatsApp. Restoring a corrupted or tampered file could inject malformed records or crash the database engine.

### Verification Protocol Before Restore:
1. Every exported backup archive (`.tmbackup`) must package:
   - `payload.json` (or database binary).
   - `manifest.json` containing `sha256_checksum`, `app_version`, `timestamp`, and `record_count`.
2. **Mandatory Checksum Verification:**
   Before parsing or replacing the active database:
   ```dart
   Future<bool> verifyBackupIntegrity(File backupFile, String expectedSha256) async {
     final bytes = await backupFile.readAsBytes();
     final digest = sha256.convert(bytes);
     return digest.toString() == expectedSha256;
   }
   ```
3. If the checksum does not match, abort restore immediately and notify the user with a `BackupFailure` alert.

---

## 4. Zero Telemetry & Anti-Exfiltration Guarantees

In accordance with **OWASP MASVS-STORAGE** and **MASVS-NETWORK**:
1. **Complete Air-Gap:**
   - The application shall contain no background analytics SDKs, ping trackers, advertisement networks, or remote telemetry loggers.
2. **Customer Data Confinement:**
   - Customer phone numbers, notes, and measurement profiles must never be serialized into unencrypted clipboard operations or public logs (`print()` or `debugPrint()`).
3. **Sharing Intent Sanitization:**
   - When generating WhatsApp or SMS slips, format only the relevant order summary. Never expose internal database IDs, hashes, or unrelated customer records.
