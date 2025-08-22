 import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_entity.dart';


 abstract class ExpensesRepository {
   Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense);
   Future<Either<Failure, List<ExpenseEntity>>> getRecent({int limit});
   Future<Either<Failure, void>> deleteExpense(int id);

    Future<Either<Failure, double>> totalIncome();
   Future<Either<Failure, double>> totalExpensesAbs();
 }