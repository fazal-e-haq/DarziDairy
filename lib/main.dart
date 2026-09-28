import 'package:flutter/material.dart';
import 'app.dart';
import 'core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local offline database
  await IsarService.instance.init();

  runApp(const TailorMasterApp());
}
