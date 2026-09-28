/// Pure Expense domain entity for Roznamcha
class ExpenseEntity {
  final int id;
  final String category;
  final double amount;
  final String? note;
  final DateTime expenseDate;
  final DateTime createdAt;

  const ExpenseEntity({
    required this.id,
    required this.category,
    required this.amount,
    this.note,
    required this.expenseDate,
    required this.createdAt,
  });
}
