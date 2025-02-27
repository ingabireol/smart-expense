// data/local_db/hive_database.dart
import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class HiveDatabase {
  final Box<Expense> _expenseBox;

  HiveDatabase(this._expenseBox);

  // Add an expense
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }

  // Get all expenses
  List<Expense> getExpenses() {
    return _expenseBox.values.toList();
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
  }

  // Update an expense
  Future<void> updateExpense(Expense expense) async {
    await _expenseBox.put(expense.id, expense);
  }
}