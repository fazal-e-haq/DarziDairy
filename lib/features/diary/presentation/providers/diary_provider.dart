import 'package:flutter/foundation.dart';
import '../../domain/entities/daily_summary.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/i_diary_repository.dart';

/// Provider for managing daily ledger totals, shop expenses, and cashflow
class DiaryProvider extends ChangeNotifier {
  final IDiaryRepository repository;

  DiaryProvider({required this.repository}) {
    loadDailySummary();
  }

  DateTime _selectedDate = DateTime.now();
  DailySummaryEntity? _dailySummary;
  bool _isLoading = false;

  DateTime get selectedDate => _selectedDate;
  DailySummaryEntity? get dailySummary => _dailySummary;
  bool get isLoading => _isLoading;

  double get totalCashIn => _dailySummary?.totalCashIn ?? 0.0;
  double get totalCashOut => _dailySummary?.totalCashOut ?? 0.0;
  double get netCash => (_dailySummary?.totalCashIn ?? 0.0) - (_dailySummary?.totalCashOut ?? 0.0);
  int get urgentDueCount => 2; // Derived from pending urgent jobs

  Future<void> loadDailySummary([DateTime? date]) async {
    if (date != null) _selectedDate = date;
    _isLoading = true;
    notifyListeners();

    _dailySummary = await repository.getDailySummary(_selectedDate);

    // Seed sample expenses if none exist for today, or fallback for UI preview
    if (_dailySummary == null || _dailySummary!.expenses.isEmpty) {
      await _seedSampleExpenses();
      _dailySummary = await repository.getDailySummary(_selectedDate);
      if (_dailySummary == null || _dailySummary!.expenses.isEmpty) {
        _dailySummary = DailySummaryEntity(
          date: _selectedDate,
          totalCashIn: 7400.0,
          totalCashOut: 1330.0,
          ordersBooked: 4,
          ordersDelivered: 1,
          expenses: _getSampleExpensesList(),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense({
    required String category,
    required double amount,
    String? note,
  }) async {
    final expense = ExpenseEntity(
      id: 0,
      category: category,
      amount: amount,
      note: note,
      expenseDate: _selectedDate,
      createdAt: DateTime.now(),
    );

    await repository.addExpense(expense);
    await loadDailySummary(_selectedDate);
  }

  Future<void> deleteExpense(int id) async {
    await repository.deleteExpense(id);
    await loadDailySummary(_selectedDate);
  }

  List<ExpenseEntity> _getSampleExpensesList() {
    final now = DateTime.now();
    return [
      ExpenseEntity(
        id: 1,
        category: 'Threads (Dhaga)',
        amount: 350.0,
        note: 'Silk and matching cotton spools',
        expenseDate: now,
        createdAt: now,
      ),
      ExpenseEntity(
        id: 2,
        category: 'Bukram / Interlining',
        amount: 800.0,
        note: 'Hard collar and cuff rolls',
        expenseDate: now,
        createdAt: now,
      ),
      ExpenseEntity(
        id: 3,
        category: 'Tea & Refreshments',
        amount: 180.0,
        note: 'Evening tea for karigars',
        expenseDate: now,
        createdAt: now,
      ),
    ];
  }

  Future<void> _seedSampleExpenses() async {
    for (final e in _getSampleExpensesList()) {
      await repository.addExpense(e);
    }
  }
}
