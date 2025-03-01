import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_expense_tracker/data/models/expense_model.dart';
import '../../presentation/provider/expense_provider.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final budgetProgress = expenseProvider.budgetProgress;
    final totalExpenses = expenseProvider.totalExpenses;
    final monthlyBudget = expenseProvider.monthlyBudget;
    final isOverspent = budgetProgress > 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildBudgetOverview(monthlyBudget, totalExpenses, budgetProgress, isOverspent),
              SizedBox(height: 20),
              Text(
                'Recent Expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...expenseProvider.expenses.map((expense) => _buildExpenseCard(expense)).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSetBudgetDialog(context),
        child: Icon(Icons.edit, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildBudgetOverview(double monthlyBudget, double totalExpenses, double budgetProgress, bool isOverspent) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Budget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '\$${monthlyBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Expenses: \$${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: budgetProgress.clamp(0.0, 1.0), // Ensure value is between 0.0 and 1.0
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(
                isOverspent ? Colors.red : Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${(budgetProgress * 100).toStringAsFixed(1)}% of budget used',
              style: TextStyle(fontSize: 14),
            ),
            if (isOverspent)
              Text(
                'You have exceeded your budget!',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(Icons.category, color: Colors.blue),
        title: Text(expense.category),
        subtitle: Text('${expense.date.toString()} - \$${expense.amount.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Add logic to delete the expense
          },
        ),
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
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                final budget = double.tryParse(budgetController.text) ?? 0.0;
                if (budget > 0) {
                  expenseProvider.setMonthlyBudget(budget);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid budget amount.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}