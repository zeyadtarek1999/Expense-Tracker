 import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/expenses_repository.dart';

class GetTotalIncomeUseCase implements UseCase<double, NoParams> {
  final ExpensesRepository repo;
  GetTotalIncomeUseCase(this.repo);

  @override
  Future<Either<Failure, double>> call(NoParams params) {
    return repo.totalIncome();
  }
}
