import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../../presentation/provider/expense_provider.dart';

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final categorySpending = expenseProvider.categorySpending;
    final monthlySpending = expenseProvider.monthlySpending;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCategorySpendingChart(categorySpending),
              SizedBox(height: 20),
              _buildMonthlySpendingChart(monthlySpending),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySpendingChart(Map<String, double> categorySpending) {
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
              'Category-wise Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 300,
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

  Widget _buildMonthlySpendingChart(Map<String, double> monthlySpending) {
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
            const Text(
              'Monthly Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: charts.BarChart(
                _createMonthlyData(monthlySpending),
                animate: true,
                defaultRenderer: charts.BarRendererConfig<String>(
                  cornerStrategy: const charts.ConstCornerStrategy(30),
                ),
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    labelRotation: 60,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 12,
                      color: charts.MaterialPalette.black,
                    ),
                  ),
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

  List<charts.Series<MonthlySpending, String>> _createMonthlyData(Map<String, double> monthlySpending) {
    final data = monthlySpending.entries.map((entry) {
      return MonthlySpending(entry.key, entry.value);
    }).toList();

    return [
      charts.Series<MonthlySpending, String>(
        id: 'Spending',
        domainFn: (MonthlySpending spending, _) => spending.month,
        measureFn: (MonthlySpending spending, _) => spending.amount,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
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

class MonthlySpending {
  final String month;
  final double amount;

  MonthlySpending(this.month, this.amount);
}