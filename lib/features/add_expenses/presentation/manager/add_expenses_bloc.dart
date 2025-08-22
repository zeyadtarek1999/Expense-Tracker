import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_date_picker.dart';
import '../../../../injection_container.dart';
import '../../../dashboard/presentation/manager/dashboard_bloc.dart';
import '../../domain/use_cases/add_expense_use_case.dart';
import '../widgets/expenses_form_widget.dart';

part 'add_expenses_event.dart';
part 'add_expenses_state.dart';

class AddExpensesBloc extends Bloc<AddExpensesEvent, AddExpensesState> {
  final AddExpenseUseCase addExpenseUseCase;

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final dateController = TextEditingController();
  final receiptController = TextEditingController();

  bool Function()? validatorOverride;

  final List<Category> categories = [
    Category('Groceries', Icons.local_grocery_store_outlined, AppColors.groceries),
    Category('Entertainment', Icons.sports_esports_outlined, AppColors.entertainment),
    Category('Gas', Icons.local_gas_station_outlined, AppColors.gas),
    Category('Shopping', Icons.shopping_bag_outlined, AppColors.shopping),
    Category('News Paper', Icons.article_outlined, AppColors.newspaper),
    Category('Transport', Icons.directions_car_outlined, AppColors.transport),
    Category('Rent', Icons.home_work_outlined, AppColors.rent),

     Category('Health', Icons.health_and_safety_outlined, AppColors.health),
    Category('Education', Icons.school_outlined, AppColors.education),
    Category('Utilities', Icons.lightbulb_outline, AppColors.utilities),
    Category('Gifts', Icons.card_giftcard_outlined, AppColors.gifts),
    Category('Travel', Icons.airplanemode_active_outlined, AppColors.travel),
    Category('Dining', Icons.restaurant_menu_outlined, AppColors.dining),
    Category('Subscriptions', Icons.subscriptions_outlined, AppColors.subscriptions),
  ];


  AddExpensesBloc(this.addExpenseUseCase) : super(const AddExpensesInitial()) {
    on<SelectEntryTypeEvent>((event, emit) {
      emit(state.copyWith(entryType: event.type, errorMessage: null));
    });

    on<SelectCategoryEvent>((event, emit) {
      emit(state.copyWith(selectedCategory: event.category, errorMessage: null));
    });

    on<SelectDateEvent>((event, emit) {
      dateController.text = event.dateText;
      emit(state.copyWith(
        selectedDate: event.date,
        dateText: event.dateText,
        errorMessage: null,
      ));
    });

    on<SelectReceiptEvent>((event, emit) async {
      try {
        if ((event.path ?? '').isEmpty) {
          receiptController.text = event.displayText;
          emit(state.copyWith(
            receiptText: event.displayText,
            receiptPath: null,
            errorMessage: null,
          ));
          return;
        }

        final savedPath = await persistReceiptToAppDir(
          originalPath: event.path!,
          suggestedName: event.displayText,
        );

        final display = p.basename(savedPath);
        receiptController.text = display;

        emit(state.copyWith(
          receiptText: display,
          receiptPath: savedPath,
          errorMessage: null,
        ));
      } catch (_) {
        emit(state.copyWith(errorMessage: 'Failed to save receipt image'));
      }
    });

    on<PickDatePressed>(_onPickDate);
    on<SaveExpenseEvent>(_onSaveExpense);
  }

  Future<void> _onPickDate(
      PickDatePressed event,
      Emitter<AddExpensesState> emit,
      ) async {
    final picked = await AppDatePicker.show(
      event.context,
      initial: event.initial,
    );
    if (picked != null) {
      final text = AppDatePicker.formatMdy(picked);
      dateController.text = text;
      emit(state.copyWith(
        selectedDate: picked,
        dateText: text,
        errorMessage: null,
      ));
    }
  }

  Future<void> _onSaveExpense(
      SaveExpenseEvent event,
      Emitter<AddExpensesState> emit,
      ) async {
    if (state.selectedCategory == null) {
      emit(state.copyWith(errorMessage: 'Please choose a category'));
      return;
    }

    final isValid = validatorOverride?.call() ?? (formKey.currentState?.validate() ?? false);
    if (!isValid) return;

    final raw = amountController.text.replaceAll(',', '').trim();
    final parsed = double.tryParse(raw) ?? 0;
    if (parsed <= 0) {
      emit(state.copyWith(errorMessage: 'Enter a valid amount'));
      return;
    }

    final signedAmount =
    state.entryType == EntryType.income ? parsed.abs() : -parsed.abs();

    emit(state.copyWith(saving: true, errorMessage: null));

    final result = await addExpenseUseCase(
      AddExpenseParams(
        category: state.selectedCategory!.name,
        amount: signedAmount,
        date: state.selectedDate ?? DateTime.now(),
        receipt: state.receiptPath ?? state.receiptText,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(saving: false, errorMessage: failure.massage)),
          (saved) async {
        getIt<DashboardBloc>().loadRecent(setLoading: true);
        emit(ExpenseSavedState(
          category: saved.category,
          amount: saved.amount,
          date: saved.date,
          receipt: saved.receipt,
        ));
      },
    );
  }

  Future<String> persistReceiptToAppDir({
    required String originalPath,
    String? suggestedName,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(docs.path, 'receipts'));
    if (!await receiptsDir.exists()) {
      await receiptsDir.create(recursive: true);
    }

    final baseName = (suggestedName?.trim().isNotEmpty == true)
        ? suggestedName!.trim()
        : p.basename(originalPath);
    final ext = p.extension(baseName).isEmpty ? '.jpg' : p.extension(baseName);
    final filename = 'receipt_${DateTime.now().millisecondsSinceEpoch}$ext';
    final destPath = p.join(receiptsDir.path, filename);

    await File(originalPath).copy(destPath);
    return destPath;
  }

  @override
  Future<void> close() {
    amountController.dispose();
    dateController.dispose();
    receiptController.dispose();
    return super.close();
  }
}
