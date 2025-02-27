// presentation/bloc/expense_bloc.dart
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc(this.repository) : super(ExpenseInitial()) {
    on<AddExpense>((event, emit) async {
      await repository.addExpense(event.expense);
      emit(ExpenseAdded());
    });
  }
}