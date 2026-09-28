import 'package:isar/isar.dart';

part 'expense_collection.g.dart';

/// Isar schema for daily shop expenditures
@collection
class ExpenseCollection {
  Id id = Isar.autoIncrement;

  String category = '';
  double amount = 0.0;
  String? note;

  @Index()
  DateTime expenseDate = DateTime.now();

  DateTime createdAt = DateTime.now();
}
