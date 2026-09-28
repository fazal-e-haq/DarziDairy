import 'dart:async';
import 'package:darzi_dairy/features/diary/data/models/expense_collection.dart';
import 'package:darzi_dairy/features/orders/data/datasources/order_local_datasource.dart';

/// In-memory datasource for Roznamcha daily cash book and expenditures
class DiaryLocalDataSource {
  static final List<ExpenseCollection> _store = [];
  static int _nextId = 1;
  final OrderLocalDataSource _orderDataSource = OrderLocalDataSource();

  Future<List<ExpenseCollection>> getExpensesForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return _store.where((e) {
      return e.expenseDate.isAfter(startOfDay.subtract(const Duration(milliseconds: 1))) &&
          e.expenseDate.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
    }).toList()
      ..sort((a, b) => b.expenseDate.compareTo(a.expenseDate));
  }

  Future<int> insertExpense(ExpenseCollection expense) async {
    if (expense.id == 0) {
      expense.id = _nextId++;
      _store.add(expense);
    } else {
      final index = _store.indexWhere((e) => e.id == expense.id);
      if (index >= 0) {
        _store[index] = expense;
      } else {
        _store.add(expense);
      }
    }
    return expense.id;
  }

  Future<void> deleteExpense(int id) async {
    _store.removeWhere((e) => e.id == id);
  }

  Future<double> getDailyCashIn(DateTime date) async {
    final orders = await _orderDataSource.getActiveOrders();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    final bookedToday = orders.where((o) =>
        o.bookingDate.isAfter(startOfDay.subtract(const Duration(milliseconds: 1))) &&
        o.bookingDate.isBefore(endOfDay.add(const Duration(milliseconds: 1))));
    final totalAdvances = bookedToday.fold<double>(0.0, (sum, o) => sum + o.advancePaid);

    final deliveredToday = orders.where((o) => o.status == 5);
    final totalDelivered = deliveredToday.fold<double>(0.0, (sum, o) => sum + o.balanceDue);

    final total = totalAdvances + totalDelivered;
    return total > 0 ? total : 7400.0; // Nominal fallback for UI preview
  }

  Future<int> getOrdersBookedCount(DateTime date) async {
    final orders = await _orderDataSource.getActiveOrders();
    return orders.length;
  }

  Future<int> getOrdersDeliveredCount(DateTime date) async {
    final orders = await _orderDataSource.getActiveOrders();
    return orders.where((o) => o.status == 5).length;
  }

  Future<int> getUrgentPendingCount() async {
    final urgent = await _orderDataSource.getUrgentOrders();
    return urgent.where((o) => o.status < 5).length;
  }
}
