import '../entities/daily_summary.dart';
import '../entities/expense.dart';

/// Abstract repository contract for daily shop cashbook and expenses
abstract class IDiaryRepository {
  Future<DailySummaryEntity> getDailySummary(DateTime date);
  Future<List<ExpenseEntity>> getExpensesForDate(DateTime date);
  Future<int> addExpense(ExpenseEntity expense);
  Future<void> deleteExpense(int id);
  Stream<DailySummaryEntity> watchDailySummary(DateTime date);
}
