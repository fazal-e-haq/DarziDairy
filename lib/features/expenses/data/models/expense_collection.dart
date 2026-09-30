import 'package:isar/isar.dart';

part 'expense_collection.g.dart';

/// Persistent Isar model for workshop expenses (Roznamcha ledger).
/// Stores daily expenses such as threads, buttons, rent, utilities, etc.
@collection
class ExpenseCollection {
  Id id = Isar.autoIncrement;

  String title = '';

  @Index()
  String category = 'Other';

  double amount = 0.0;

  String note = '';

  @Index()
  DateTime date = DateTime.now();

  DateTime createdAt = DateTime.now();

  @Index()
  bool isDeleted = false;
}
