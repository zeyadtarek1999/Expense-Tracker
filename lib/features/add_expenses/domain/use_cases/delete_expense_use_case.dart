 import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/expenses_repository.dart';

class DeleteExpenseUseCase implements UseCase<void, int> {
  final ExpensesRepository repo;
  DeleteExpenseUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(int id) {
    return repo.deleteExpense(id);
  }
}
