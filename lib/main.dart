import 'package:flutter/material.dart';
import 'app.dart';
import 'core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize production Isar offline database
  await IsarService.instance.init();

  runApp(const TailorMasterApp());
}
