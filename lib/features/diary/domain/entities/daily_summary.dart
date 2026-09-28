import 'expense.dart';

/// Aggregated daily financial model (revenue, pending, expense, net cash)
class DailySummaryEntity {
  final DateTime date;
  final double totalCashIn;
  final double totalCashOut;
  final int ordersBooked;
  final int ordersDelivered;
  final List<ExpenseEntity> expenses;

  const DailySummaryEntity({
    required this.date,
    required this.totalCashIn,
    required this.totalCashOut,
    this.ordersBooked = 0,
    this.ordersDelivered = 0,
    this.expenses = const [],
  });

  double get netCash => totalCashIn - totalCashOut;
}
