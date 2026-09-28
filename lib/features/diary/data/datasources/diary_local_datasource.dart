import 'package:isar/isar.dart';
import 'package:darzi_dairy/core/database/isar_service.dart';
import 'package:darzi_dairy/features/diary/data/models/expense_collection.dart';
import 'package:darzi_dairy/features/orders/data/models/order_collection.dart';

/// Direct Isar datasource for Roznamcha daily cash book and expenditures with defensive fallback
class DiaryLocalDataSource {
  Isar? get _isar => IsarService.instance.isOpen ? IsarService.instance.isar : null;

  Future<List<ExpenseCollection>> getExpensesForDate(DateTime date) async {
    final db = _isar;
    if (db == null) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return db.expenseCollections
        .filter()
        .expenseDateBetween(startOfDay, endOfDay)
        .sortByExpenseDateDesc()
        .findAll();
  }

  Future<int> insertExpense(ExpenseCollection expense) async {
    final db = _isar;
    if (db == null) return expense.id;
    return db.writeTxn(() => db.expenseCollections.put(expense));
  }

  Future<void> deleteExpense(int id) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() => db.expenseCollections.delete(id));
  }

  Future<double> getDailyCashIn(DateTime date) async {
    final db = _isar;
    if (db == null) return 0.0;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // 1. Advances from orders booked today
    final bookedToday = await db.orderCollections
        .filter()
        .bookingDateBetween(startOfDay, endOfDay)
        .findAll();
    final totalAdvances = bookedToday.fold<double>(0.0, (sum, o) => sum + o.advancePaid);

    // 2. Deliveries cleared today (balance collections)
    final deliveredToday = await db.orderCollections
        .filter()
        .statusEqualTo(5) // Delivered
        .findAll();
    final totalDelivered = deliveredToday.fold<double>(0.0, (sum, o) => sum + o.balanceDue);

    return totalAdvances + totalDelivered;
  }

  Future<int> getOrdersBookedCount(DateTime date) async {
    final db = _isar;
    if (db == null) return 0;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    return db.orderCollections
        .filter()
        .bookingDateBetween(startOfDay, endOfDay)
        .count();
  }

  Future<int> getOrdersDeliveredCount(DateTime date) async {
    final db = _isar;
    if (db == null) return 0;
    return db.orderCollections.filter().statusEqualTo(5).count();
  }

  Future<int> getUrgentPendingCount() async {
    final db = _isar;
    if (db == null) return 0;
    return db.orderCollections
        .filter()
        .isDeletedEqualTo(false)
        .isUrgentEqualTo(true)
        .and()
        .statusLessThan(5)
        .count();
  }
}
