// data/repositories/expense_repository.dart
import '../local_db/hive_database.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  final HiveDatabase _localDatabase;

  ExpenseRepository(this._localDatabase);

  Future<void> addExpense(Expense expense) async {
    await _localDatabase.addExpense(expense);
  }

  List<Expense> getExpenses() {
    return _localDatabase.getExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _localDatabase.deleteExpense(id);
  }

  Future<void> updateExpense(Expense expense) async {
    await _localDatabase.updateExpense(expense);
  }
}