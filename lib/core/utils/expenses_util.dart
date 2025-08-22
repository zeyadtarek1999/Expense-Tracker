import '../../features/add_expenses/domain/entities/expense_entity.dart';

class ExpenseUtils {
  const ExpenseUtils._();

  static double totalExpenses(List<ExpenseEntity> list) {
    double total = 0;
    for (final e in list) {
      if (e.amount < 0) total += e.amount.abs();
    }
    return total;
  }

  static double totalIncome(List<ExpenseEntity> list) {
    double total = 0;
    for (final e in list) {
      if (e.amount > 0) total += e.amount;
    }
    return total;
  }

  static double netTotal(List<ExpenseEntity> list) {
    return totalIncome(list) - totalExpenses(list);
  }

   static String formatAmount(num value) {
    final isInt = value % 1 == 0;
    return isInt ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
}
