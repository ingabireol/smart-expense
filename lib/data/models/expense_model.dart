// data/models/expense_model.dart
import 'package:hive/hive.dart';

part 'expense_model.g.dart'; // Generated file

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String description;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });
}