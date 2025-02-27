// presentation/pages/budget_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/provider/expense_provider.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final budgetProgress = expenseProvider.budgetProgress;
    final totalExpenses = expenseProvider.totalExpenses;
    final monthlyBudget = expenseProvider.monthlyBudget;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Budget: \$${monthlyBudget.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: budgetProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(
                    budgetProgress > 1.0 ? Colors.red : Colors.blue,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${(budgetProgress * 100).toStringAsFixed(1)}% of budget used',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenseProvider.expenses.length,
              itemBuilder: (context, index) {
                final expense = expenseProvider.expenses[index];
                return ListTile(
                  title: Text(expense.category),
                  subtitle: Text('\$${expense.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSetBudgetDialog(context),
        child: Icon(Icons.edit),
      ),
    );
  }

  void _showSetBudgetDialog(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Monthly Budget'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Budget',
              hintText: 'Enter your monthly budget',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text) ?? 0.0;
                expenseProvider.setMonthlyBudget(budget);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}