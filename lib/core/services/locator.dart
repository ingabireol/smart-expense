// core/services/locator.dart
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:smart_expense_tracker/data/local_db/hive_database.dart';
import 'package:smart_expense_tracker/data/models/expense_model.dart';
import 'package:smart_expense_tracker/data/repositories/expense_repository.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Initialize Hive box
  final expenseBox = Hive.box<Expense>('expenses');

  // Register services
  locator.registerSingleton<HiveDatabase>(HiveDatabase(expenseBox));
  locator.registerSingleton<ExpenseRepository>(ExpenseRepository(locator<HiveDatabase>()));
}