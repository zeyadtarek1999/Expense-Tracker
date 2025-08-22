// lib/features/add_expenses/data/repositories/expenses_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../data_sources/add_expenses_local_data_source.dart';
import '../models/expenses_model.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesLocalDataSource local;

  ExpensesRepositoryImpl(this.local);

  @override
  Future<Either<Failure, ExpenseEntity>> addExpense(ExpenseEntity expense) async {
    try {
      final id = await local.insertExpense(ExpenseModel.fromEntity(expense));
      return Right(
        ExpenseEntity(
          id: id,
          category: expense.category,
          amount: expense.amount,
          date: expense.date,
          receipt: expense.receipt,
        ),
      );
    } catch (e) {
      return Left(CacheFailure('Failed to insert expense: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseEntity>>> getRecent({int limit = 50}) async {
    try {
      final models = await local.getRecent(limit: limit);
      final list = models.map((m) => m.toEntity()).toList();
      return Right(list);
    } catch (e) {
      return Left(CacheFailure('Failed to read expenses: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(int id) async {
    try {
      await local.deleteExpense(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to delete expense: $e'));
    }
  }

   @override
  Future<Either<Failure, double>> totalIncome() async {
    try {
      final total = await local.totalIncome();
      return Right(total);
    } catch (e) {
      return Left(CacheFailure('Failed to compute total income: $e'));
    }
  }

   @override
  Future<Either<Failure, double>> totalExpensesAbs() async {
    try {
      final total = await local.totalExpensesAbs();
      return Right(total);
    } catch (e) {
      return Left(CacheFailure('Failed to compute total expenses: $e'));
    }
  }
}
