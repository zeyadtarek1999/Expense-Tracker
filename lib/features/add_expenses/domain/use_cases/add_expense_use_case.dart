import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/repositories/expenses_repository.dart';

class AddExpenseUseCase implements UseCase<ExpenseEntity, AddExpenseParams> {
  final ExpensesRepository repo;
  AddExpenseUseCase(this.repo);

  @override
  Future<Either<Failure, ExpenseEntity>> call(AddExpenseParams params) {
    return repo.addExpense(
      ExpenseEntity(
        category: params.category,
        amount: params.amount,
        date: params.date,
        receipt: params.receipt,
      ),
    );
  }
}

class AddExpenseParams {
  final String category;
  final double amount;
  final DateTime date;
  final String? receipt;

  AddExpenseParams({
    required this.category,
    required this.amount,
    required this.date,
    this.receipt,
  });
}
