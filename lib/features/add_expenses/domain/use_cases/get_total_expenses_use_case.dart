 import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/expenses_repository.dart';

class GetTotalExpensesAbsUseCase implements UseCase<double, NoParams> {
  final ExpensesRepository repo;
  GetTotalExpensesAbsUseCase(this.repo);

  @override
  Future<Either<Failure, double>> call(NoParams params) {
    return repo.totalExpensesAbs();
  }
}
