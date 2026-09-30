import 'package:flutter/foundation.dart';
import '../../data/repositories/expense_repository.dart';
import '../../domain/entities/expense_entity.dart';

/// Provider managing workshop expense state, totals, and persistence
class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;

  List<ExpenseEntity> _expenses = [];
  bool _isLoading = false;

  ExpenseProvider({required this.repository}) {
    loadExpenses();
  }

  List<ExpenseEntity> get expenses => List.unmodifiable(_expenses);
  bool get isLoading => _isLoading;

  /// Total sum of all recorded expenses in Rs
  double get totalExpenses =>
      _expenses.fold(0.0, (sum, item) => sum + item.amount);

  /// Total expenses recorded today
  double get todayExpenses {
    final now = DateTime.now();
    return _expenses
        .where((e) =>
            e.date.year == now.year &&
            e.date.month == now.month &&
            e.date.day == now.day)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Total expenses recorded this month
  double get thisMonthExpenses {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  /// Loads all expenses from the persistent repository
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await repository.getExpenses();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a new expense item to the ledger
  Future<void> addExpense({
    required String title,
    required String category,
    required double amount,
    String note = '',
    DateTime? date,
  }) async {
    final expense = ExpenseEntity(
      id: 0,
      title: title.trim(),
      category: category.trim(),
      amount: amount,
      note: note.trim(),
      date: date ?? DateTime.now(),
      createdAt: DateTime.now(),
    );

    await repository.saveExpense(expense);
    await loadExpenses();
  }

  /// Deletes an expense item by ID
  Future<void> deleteExpense(int id) async {
    await repository.deleteExpense(id);
    await loadExpenses();
  }
}
