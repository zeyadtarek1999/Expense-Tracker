part of 'add_expenses_bloc.dart';

@immutable
class AddExpensesState {
  final EntryType entryType;
  final Category? selectedCategory;
  final DateTime? selectedDate;
  final String dateText;
  final String receiptText;
  final String? receiptPath;
  final bool saving;
  final String? errorMessage;

  const AddExpensesState({
    required this.entryType,
    this.selectedCategory,
    this.selectedDate,
    this.dateText = '',
    this.receiptText = '',
    this.receiptPath,
    this.saving = false,
    this.errorMessage,
  });

  AddExpensesState copyWith({
    EntryType? entryType,
    Category? selectedCategory,
    DateTime? selectedDate,
    String? dateText,
    String? receiptText,
    String? receiptPath,
    bool? saving,
    String? errorMessage,
  }) {
    return AddExpensesState(
      entryType: entryType ?? this.entryType,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      dateText: dateText ?? this.dateText,
      receiptText: receiptText ?? this.receiptText,
      receiptPath: receiptPath ?? this.receiptPath,
      saving: saving ?? this.saving,
      errorMessage: errorMessage,
    );
  }
}

class AddExpensesInitial extends AddExpensesState {
  const AddExpensesInitial() : super(entryType: EntryType.expense);
}

class ExpenseSavedState extends AddExpensesState {
  final String category;
  final double amount;
  final DateTime date;
  final String? receipt;

  const ExpenseSavedState({
    required this.category,
    required this.amount,
    required this.date,
    this.receipt,
  }) : super(entryType: EntryType.expense, saving: false);
}
