// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_expense_tracker/core/services/locator.dart';
import 'package:smart_expense_tracker/data/models/budget_model.dart';
import 'package:smart_expense_tracker/data/models/expense_model.dart';
import 'package:smart_expense_tracker/data/local_db/hive_database.dart';
import 'package:smart_expense_tracker/data/repositories/expense_repository.dart';
import 'package:smart_expense_tracker/presentation/pages/home_page.dart';
import 'package:smart_expense_tracker/presentation/pages/add_expense_page.dart';
import 'package:smart_expense_tracker/presentation/pages/budget_page.dart';
import 'package:smart_expense_tracker/presentation/pages/onboarding_page.dart';
import 'package:smart_expense_tracker/presentation/pages/reports_page.dart';
import 'package:smart_expense_tracker/presentation/pages/savings_goals_page.dart';
// import 'package:smart_expense_tracker/presentation/pages/savings_page.dart';
import 'package:smart_expense_tracker/presentation/provider/expense_provider.dart';
// import 'package:smart_expense_tracker/presentation/providers/expense_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(BudgetAdapter());

  // Open Hive box for expenses
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Budget>('budget');

  // Set up dependency injection
  setupLocator();

  // Initialize dependencies
  final expenseBox = Hive.box<Expense>('expenses');
  final localDatabase = HiveDatabase(expenseBox);
  final expenseRepository = ExpenseRepository(localDatabase);

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        Provider<ExpenseRepository>(create: (_) => expenseRepository),
        ChangeNotifierProvider(
          create: (context) => ExpenseProvider(expenseRepository)..fetchExpenses(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/add-expense': (context) => AddExpensePage(),
        '/budget': (context) => BudgetPage(),
        '/reports': (context) => ReportsPage(),
        '/savings': (context) => SavingsGoalsPage(),
        '/onboard': (context) => OnboardingPage(),
      },
    );
  }
}