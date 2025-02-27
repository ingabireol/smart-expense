// presentation/pages/reports_page.dart
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Category-wise Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: PieChart(_createCategoryData(categorySpending)),
            ),
            SizedBox(height: 16),
            Text(
              'Monthly Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: BarChart(_createMonthlyData(monthlySpending)),
            ),
          ],
        ),
      ),
    );
  }

  // Create data for the pie chart
  List<charts.Series<MapEntry<String, double>, String>> _createCategoryData(
      Map<String, double> categorySpending) {
    final data = categorySpending.entries.toList();
    return [
      charts.Series<MapEntry<String, double>, String>(
        id: 'Spending',
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        data: data,
        labelAccessorFn: (entry, _) => '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
      )
    ];
  }

  // Create data for the bar chart
  List<charts.Series<MapEntry<String, double>, String>> _createMonthlyData(
      Map<String, double> monthlySpending) {
    final data = monthlySpending.entries.toList();
    return [
      charts.Series<MapEntry<String, double>, String>(
        id: 'Spending',
        domainFn: (entry, _) => entry.key,
        measureFn: (entry, _) => entry.value,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];
  }
}

// Pie Chart Widget
class PieChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;

  PieChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      seriesList,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.auto,
          ),
        ],
      ),
    );
  }
}

// Bar Chart Widget
class BarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;

  BarChart(this.seriesList);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 60,
        ),
      ),
    );
  }
}