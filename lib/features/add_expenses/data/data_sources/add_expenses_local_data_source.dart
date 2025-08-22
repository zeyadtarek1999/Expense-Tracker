import '../../../../core/helpers/sql_database.dart';
import '../models/expenses_model.dart';

abstract class ExpensesLocalDataSource {
  Future<int> insertExpense(ExpenseModel model);
  Future<List<ExpenseModel>> getRecent({int limit});
  Future<int> deleteExpense(int id);

   Future<double> totalIncome();
  Future<double> totalExpensesAbs();
}

class ExpensesLocalDataSourceImpl implements ExpensesLocalDataSource {
  final SqlDatabase db;

  ExpensesLocalDataSourceImpl(this.db);

  @override
  Future<int> insertExpense(ExpenseModel model) {
    final isIncome = model.amount >= 0;
    return db.insertExpense(
      category: model.category,
      amount: model.amount.abs(),
      date: model.date,
      receipt: model.receipt,
      isIncome: isIncome,
    );
  }

  @override
  Future<List<ExpenseModel>> getRecent({int limit = 50}) async {
    final rows = await db.getRecentExpenses(limit: limit);
    return rows.map(ExpenseModel.fromMap).toList();
  }

  @override
  Future<int> deleteExpense(int id) {
    return db.delete(
      SqlDatabase.tableExpenses,
      where: '${SqlDatabase.colId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<double> totalIncome() => db.totalIncome();

  @override
  Future<double> totalExpensesAbs() => db.totalExpensesAbs();
}
