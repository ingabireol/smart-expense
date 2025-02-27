// presentation/providers/expense_provider.dart
import 'package:flutter/cupertino.dart';
import 'package:smart_expense_tracker/data/models/expense_model.dart';
import 'package:smart_expense_tracker/data/repositories/expense_repository.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseRepository _expenseRepository;

  ExpenseProvider(this._expenseRepository);

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  double _monthlyBudget = 0.0;
  double get monthlyBudget => _monthlyBudget;

  // Fetch all expenses
  Future<void> fetchExpenses() async {
    _expenses = _expenseRepository.getExpenses();
    notifyListeners();
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _expenseRepository.addExpense(expense);
    await fetchExpenses(); // Refresh the list
  }

  // Delete an expense
  Future<void> deleteExpense(String id) async {
    await _expenseRepository.deleteExpense(id);
    await fetchExpenses(); // Refresh the list
  }

  // Set monthly budget
  void setMonthlyBudget(double budget) {
    _monthlyBudget = budget;
    notifyListeners();
  }

  // Calculate total expenses
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Calculate budget progress
  double get budgetProgress {
    if (_monthlyBudget == 0.0) return 0.0;
    return totalExpenses / _monthlyBudget;
  }

  // Calculate category-wise spending
  Map<String, double> get categorySpending {
    final Map<String, double> spending = {};
    for (final expense in _expenses) {
      spending[expense.category] = (spending[expense.category] ?? 0.0) + expense.amount;
    }
    return spending;
  }

  // Calculate monthly spending
  Map<String, double> get monthlySpending {
    final Map<String, double> spending = {};
    for (final expense in _expenses) {
      final month = '${expense.date.year}-${expense.date.month}';
      spending[month] = (spending[month] ?? 0.0) + expense.amount;
    }
    return spending;
  }
}