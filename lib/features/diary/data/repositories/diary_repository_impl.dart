import '../../domain/entities/daily_summary.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/i_diary_repository.dart';
import '../datasources/diary_local_datasource.dart';
import '../models/expense_collection.dart';

/// Concrete repository implementation for Roznamcha daily ledger
class DiaryRepositoryImpl implements IDiaryRepository {
  final DiaryLocalDataSource localDataSource;

  DiaryRepositoryImpl({required this.localDataSource});

  @override
  Future<DailySummaryEntity> getDailySummary(DateTime date) async {
    final expenses = await getExpensesForDate(date);
    final totalCashOut = expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
    final totalCashIn = await localDataSource.getDailyCashIn(date);
    final bookedCount = await localDataSource.getOrdersBookedCount(date);
    final deliveredCount = await localDataSource.getOrdersDeliveredCount(date);

    return DailySummaryEntity(
      date: date,
      totalCashIn: totalCashIn,
      totalCashOut: totalCashOut,
      ordersBooked: bookedCount,
      ordersDelivered: deliveredCount,
      expenses: expenses,
    );
  }

  @override
  Future<List<ExpenseEntity>> getExpensesForDate(DateTime date) async {
    final list = await localDataSource.getExpensesForDate(date);
    return list.map(_toEntity).toList();
  }

  @override
  Future<int> addExpense(ExpenseEntity expense) async {
    final model = _toModel(expense);
    return localDataSource.insertExpense(model);
  }

  @override
  Future<void> deleteExpense(int id) async {
    await localDataSource.deleteExpense(id);
  }

  @override
  Stream<DailySummaryEntity> watchDailySummary(DateTime date) async* {
    yield await getDailySummary(date);
  }

  static ExpenseEntity _toEntity(ExpenseCollection m) {
    return ExpenseEntity(
      id: m.id,
      category: m.category,
      amount: m.amount,
      note: m.note,
      expenseDate: m.expenseDate,
      createdAt: m.createdAt,
    );
  }

  static ExpenseCollection _toModel(ExpenseEntity e) {
    final m = ExpenseCollection()
      ..category = e.category
      ..amount = e.amount
      ..note = e.note
      ..expenseDate = e.expenseDate
      ..createdAt = e.createdAt;
    if (e.id > 0) {
      m.id = e.id;
    }
    return m;
  }
}
