import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';


class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    int? id,
    required String category,
    required double amount,
    required DateTime date,
    String? receipt,
  }) : super(id: id, category: category, amount: amount, date: date, receipt: receipt);

  factory ExpenseModel.fromMap(Map<String, Object?> map) => ExpenseModel(
    id: map['id'] as int?,
    category: map['category'] as String,
    amount: (map['amount'] as num).toDouble(),
    date: DateTime.parse(map['date'] as String),
    receipt: map['receipt'] as String?,
  );

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'category': category,
    'amount': amount,
    'date': date.toIso8601String(),
    'receipt': receipt,
  };

  factory ExpenseModel.fromEntity(ExpenseEntity e) => ExpenseModel(
    id: e.id,
    category: e.category,
    amount: e.amount,
    date: e.date,
    receipt: e.receipt,
  );

  ExpenseEntity toEntity() => ExpenseEntity(
    id: id,
    category: category,
    amount: amount,
    date: date,
    receipt: receipt,
  );
}
