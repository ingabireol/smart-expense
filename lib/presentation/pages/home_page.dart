import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smart_expense_tracker/data/models/expense_model.dart';
import '../../presentation/provider/expense_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to other pages based on index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/budget');
        break;
      case 2:
        Navigator.pushNamed(context, '/reports');
        break;
      case 3:
        Navigator.pushNamed(context, '/savings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;
    final totalExpenses = expenseProvider.totalExpenses;
    final monthlyBudget = expenseProvider.monthlyBudget;
    final remainingBudget = monthlyBudget - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(remainingBudget, monthlyBudget),
              SizedBox(height: 20),
              _buildExpenseChart(expenseProvider.categorySpending),
              SizedBox(height: 20),
              Text(
                'Recent Expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...expenses.map((expense) => _buildExpenseCard(expense)).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-expense');
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: 'Savings',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile.png'), // Add a profile image
                ),
                SizedBox(height: 10),
                Text(
                  'John Doe', // Replace with user's name
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'john.doe@example.com', // Replace with user's email
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            onTap: () {
              // Navigate to help page
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double remainingBudget, double monthlyBudget) {
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
              'Remaining Budget',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              '\$${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            LinearProgressIndicator(
              value: monthlyBudget == 0 ? 0.0 : (remainingBudget / monthlyBudget).clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(Map<String, double> categorySpending) {
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
              'Spending by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: charts.PieChart(
                _createCategoryData(categorySpending),
                animate: true,
                defaultRenderer: charts.ArcRendererConfig<String>(
                  arcWidth: 60,
                  arcRendererDecorators: [
                    charts.ArcLabelDecorator<String>(
                      labelPosition: charts.ArcLabelPosition.auto,
                      insideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 14,
                        color: charts.MaterialPalette.white,
                      ),
                      outsideLabelStyleSpec: charts.TextStyleSpec(
                        fontSize: 14,
                        color: charts.MaterialPalette.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<CategorySpending, String>> _createCategoryData(Map<String, double> categorySpending) {
    final data = categorySpending.entries.map((entry) {
      return CategorySpending(entry.key, entry.value);
    }).toList();

    return [
      charts.Series<CategorySpending, String>(
        id: 'Spending',
        domainFn: (CategorySpending spending, _) => spending.category,
        measureFn: (CategorySpending spending, _) => spending.amount,
        data: data,
        colorFn: (CategorySpending spending, _) => _getCategoryColor(spending.category),
        labelAccessorFn: (CategorySpending spending, _) =>
        '${spending.category}: \$${spending.amount.toStringAsFixed(2)}',
      )
    ];
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

  // Helper method to assign colors to categories
  charts.Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return charts.MaterialPalette.red.shadeDefault;
      case 'Transport':
        return charts.MaterialPalette.blue.shadeDefault;
      case 'Entertainment':
        return charts.MaterialPalette.green.shadeDefault;
      case 'Other':
        return charts.MaterialPalette.purple.shadeDefault;
      default:
        return charts.MaterialPalette.gray.shadeDefault;
    }
  }
}

class CategorySpending {
  final String category;
  final double amount;

  CategorySpending(this.category, this.amount);
}