part of 'add_expenses_bloc.dart';

enum EntryType { expense, income }

@immutable
abstract class AddExpensesEvent {
  const AddExpensesEvent();
}

class SelectEntryTypeEvent extends AddExpensesEvent {
  final EntryType type;
  const SelectEntryTypeEvent(this.type);
}

class SelectCategoryEvent extends AddExpensesEvent {
  final Category category;
  const SelectCategoryEvent(this.category);
}

class SelectDateEvent extends AddExpensesEvent {
  final DateTime date;
  final String dateText;
  const SelectDateEvent(this.date, this.dateText);
}

class PickDatePressed extends AddExpensesEvent {
  final BuildContext context;
  final DateTime? initial;
  const PickDatePressed(this.context, this.initial);
}

class SelectReceiptEvent extends AddExpensesEvent {
  final String displayText;
  final String? path;
  const SelectReceiptEvent(this.displayText, [this.path]);
}

class SaveExpenseEvent extends AddExpensesEvent {
  const SaveExpenseEvent();
}
