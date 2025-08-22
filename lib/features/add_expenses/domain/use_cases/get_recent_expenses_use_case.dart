 import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_entity.dart';
import '../repositories/expenses_repository.dart';

class GetRecentExpensesUseCase
    implements UseCase<List<ExpenseEntity>, GetRecentParams> {
  final ExpensesRepository repo;
  GetRecentExpensesUseCase(this.repo);

  @override
  Future<Either<Failure, List<ExpenseEntity>>> call(GetRecentParams params) {
    return repo.getRecent(limit: params.limit);
  }
}

class GetRecentParams {
  final int limit;
  GetRecentParams({this.limit = 50});
}
