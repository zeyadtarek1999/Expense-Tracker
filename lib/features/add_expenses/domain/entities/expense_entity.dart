 class ExpenseEntity {
  final int? id;
  final String category;
  final double amount;
  final DateTime date;
  final String? receipt;

  const ExpenseEntity({
    this.id,
    required this.category,
    required this.amount,
    required this.date,
    this.receipt,
  });

  ExpenseEntity copyWith({
    int? id,
    String? category,
    double? amount,
    DateTime? date,
    String? receipt,
  }) =>
      ExpenseEntity(
        id: id ?? this.id,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        receipt: receipt ?? this.receipt,
      );

  Map<String, Object?> toMap() => {
    'id': id,
    'category': category,
    'amount': amount,
    'date': date.toIso8601String(),
    'receipt': receipt,
  };

  factory ExpenseEntity.fromMap(Map<String, Object?> m) => ExpenseEntity(
    id: m['id'] as int?,
    category: m['category'] as String,
    amount: (m['amount'] as num).toDouble(),
    date: DateTime.parse(m['date'] as String),
    receipt: m['receipt'] as String?,
  );
}
