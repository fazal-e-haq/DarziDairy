import 'package:flutter_test/flutter_test.dart';
import 'package:darzi_dairy/features/expenses/data/repositories/expense_repository.dart';
import 'package:darzi_dairy/features/expenses/presentation/providers/expense_provider.dart';

void main() {
  group('Expense Tracker & Repository Tests', () {
    late ExpenseRepository repository;
    late ExpenseProvider provider;

    setUp(() {
      repository = ExpenseRepository();
      provider = ExpenseProvider(repository: repository);
    });

    test('Add expense updates totalExpenses and list correctly', () async {
      await provider.addExpense(
        title: 'White Thread Spools',
        category: 'Threads (دھاگہ)',
        amount: 450.0,
      );

      expect(provider.expenses.length, greaterThanOrEqualTo(1));
      expect(provider.totalExpenses, greaterThanOrEqualTo(450.0));

      final added = provider.expenses.firstWhere((e) => e.title == 'White Thread Spools');
      expect(added.amount, 450.0);
      expect(added.category, 'Threads (دھاگہ)');
    });

    test('Multiple expenses calculate total correctly and delete works', () async {
      await provider.addExpense(
        title: 'Buttons Box',
        category: 'Buttons (بٹن)',
        amount: 300.0,
      );
      await provider.addExpense(
        title: 'Shop Electricity',
        category: 'Electricity (بجلی بل)',
        amount: 1200.0,
      );

      final initialTotal = provider.totalExpenses;
      expect(initialTotal, greaterThanOrEqualTo(1500.0));

      final buttonExpense = provider.expenses.firstWhere((e) => e.title == 'Buttons Box');
      await provider.deleteExpense(buttonExpense.id);

      expect(provider.totalExpenses, initialTotal - 300.0);
    });
  });
}
