// domain/use_cases/check_budget.dart
import 'package:smart_expense_tracker/data/repositories/expense_repository.dart';

class CheckBudget {
  final ExpenseRepository repository;

  CheckBudget(this.repository);

  Future<bool> isOverBudget(double monthlyBudget) async {
    final expenses = await repository.getExpenses();
    final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    return total > monthlyBudget;
  }
}