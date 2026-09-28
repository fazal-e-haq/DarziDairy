import 'package:flutter/material.dart';
import 'app.dart';
// import 'core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local offline database
  // Commented out temporarily for UI preview without local native DB requirement:
  // await IsarService.instance.init();

  runApp(const TailorMasterApp());
}
