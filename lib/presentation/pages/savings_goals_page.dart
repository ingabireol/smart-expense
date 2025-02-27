// presentation/pages/savings_goals_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavingsGoalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Savings Goals'),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Goal $index'),
              subtitle: LinearProgressIndicator(
                value: 0.5, // Example: 50% progress
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add goal screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}