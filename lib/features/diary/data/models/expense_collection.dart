/// Schema for daily shop expenditures
class ExpenseCollection {
  int id = 0;

  String category = '';
  double amount = 0.0;
  String? note;

  DateTime expenseDate = DateTime.now();

  DateTime createdAt = DateTime.now();
}
