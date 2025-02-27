// // test/domain/use_cases/check_budget_test.dart
// import 'package:smart_expense_tracker/domain/use_cases/check_budget.dart';
//
// void main() {
//   late CheckBudget checkBudget;
//   late MockExpenseRepository mockRepository;
//
//   setUp(() {
//     mockRepository = MockExpenseRepository();
//     checkBudget = CheckBudget(mockRepository);
//   });
//
//   test('should return true if expenses exceed budget', () async {
//     when(mockRepository.getExpenses()).thenAnswer((_) async => [
//       Expense(id: '1', amount: 100, category: 'Food', date: DateTime.now(), description: 'Lunch'),
//     ]);
//
//     final result = await checkBudget.isOverBudget(50);
//     expect(result, true);
//   });
// }