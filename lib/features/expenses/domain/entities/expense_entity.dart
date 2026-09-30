/// Domain entity representing a workshop expense item.
class ExpenseEntity {
  final int id;
  final String title;
  final String category;
  final double amount;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  const ExpenseEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    this.note = '',
    required this.date,
    required this.createdAt,
  });
}
