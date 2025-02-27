// data/models/savings_goal_model.dart
class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
  });
}