 import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/error/failures.dart';
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/add_expenses/domain/use_cases/add_expense_use_case.dart';
import 'package:expense_tracker/features/add_expenses/presentation/manager/add_expenses_bloc.dart';
import 'package:expense_tracker/features/add_expenses/presentation/widgets/expenses_form_widget.dart';
import 'package:expense_tracker/features/dashboard/presentation/manager/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockAddExpenseUseCase extends Mock implements AddExpenseUseCase {}
class MockDashboardBloc extends Mock implements DashboardBloc {}
class _FakeAddExpenseParams extends Fake implements AddExpenseParams {}

void main() {
  final getIt = GetIt.instance;

  late MockAddExpenseUseCase mockAddExpenseUseCase;
  late MockDashboardBloc mockDashboardBloc;

  setUpAll(() {
    registerFallbackValue(_FakeAddExpenseParams());
    if (getIt.isRegistered<DashboardBloc>()) {
      getIt.unregister<DashboardBloc>();
    }
    mockDashboardBloc = MockDashboardBloc();
    when(() => mockDashboardBloc.loadRecent(
      avatarUrl: any(named: 'avatarUrl'),
      setLoading: any(named: 'setLoading'),
      setRefreshing: any(named: 'setRefreshing'),
      userName: any(named: 'userName'),
    )).thenReturn(null);
    getIt.registerSingleton<DashboardBloc>(mockDashboardBloc);
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  setUp(() {
    mockAddExpenseUseCase = MockAddExpenseUseCase();
  });

  group('_onSaveExpense', () {
    const testCategory = Category(
      'Groceries',
      Icons.local_grocery_store_outlined,
      Colors.green,
    );

    blocTest<AddExpensesBloc, AddExpensesState>(
      'emits error when no category is selected',
      build: () {
        final b = AddExpensesBloc(mockAddExpenseUseCase);
        b.validatorOverride = () => true;
        return b;
      },
      act: (b) {
        b.amountController.text = '100';
        b.add(const SaveExpenseEvent());
      },
      expect: () => [
        isA<AddExpensesState>()
            .having((s) => s.errorMessage, 'error', 'Please choose a category'),
      ],
      verify: (b) {
        final state = b.state;
        print('Result: ${state.errorMessage}');
      },
    );

    blocTest<AddExpensesBloc, AddExpensesState>(
      'emits error when amount is invalid (<= 0)',
      build: () {
        final b = AddExpensesBloc(mockAddExpenseUseCase);
        b.validatorOverride = () => true;
        return b;
      },
      act: (b) {
        b.add(const SelectCategoryEvent(testCategory));
        b.amountController.text = '0';
        b.add(const SaveExpenseEvent());
      },
      expect: () => [
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
      ],
      verify: (b) {
        print('Selected: ${b.state.selectedCategory?.name}');
        print('Result: ${b.state.errorMessage}');
      },
    );

    blocTest<AddExpensesBloc, AddExpensesState>(
      'expense: calls usecase and emits ExpenseSavedState with negative amount',
      build: () {
        when(() => mockAddExpenseUseCase(any())).thenAnswer(
              (_) async => Right(
            ExpenseEntity(
              category: 'Groceries',
              amount: -100,
              date: DateTime(2024, 1, 1),
              receipt: 'receipt.jpg',
            ),
          ),
        );
        final b = AddExpensesBloc(mockAddExpenseUseCase);
        b.validatorOverride = () => true;
        return b;
      },
      act: (b) {
        b.add(const SelectCategoryEvent(testCategory));
        b.add(const SelectEntryTypeEvent(EntryType.expense));
        b.amountController.text = '100';
        b.dateController.text = '01/01/2024';
        b.add(const SaveExpenseEvent());
      },
      expect: () => [
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<ExpenseSavedState>(),
      ],
      verify: (b) {
        final state = b.state;
        print('Selected: ${state.selectedCategory?.name}');
        if (state is ExpenseSavedState) {
          print('Result: Saved ${state.amount} in ${state.category}');
        }
      },
    );

    blocTest<AddExpensesBloc, AddExpensesState>(
      'income: positive amount saved',
      build: () {
        when(() => mockAddExpenseUseCase(any())).thenAnswer(
              (_) async => Right(
            ExpenseEntity(
              category: 'Groceries',
              amount: 200,
              date: DateTime(2024, 1, 1),
            ),
          ),
        );
        final b = AddExpensesBloc(mockAddExpenseUseCase);
        b.validatorOverride = () => true;
        return b;
      },
      act: (b) {
        b.add(const SelectCategoryEvent(testCategory));
        b.add(const SelectEntryTypeEvent(EntryType.income));
        b.amountController.text = '200';
        b.add(const SaveExpenseEvent());
      },
      expect: () => [
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<ExpenseSavedState>(),
      ],
      verify: (b) {
        final state = b.state;
        print('Selected: ${state.selectedCategory?.name}');
        if (state is ExpenseSavedState) {
          print('Result: Saved ${state.amount} in ${state.category}');
        }
      },
    );

    blocTest<AddExpensesBloc, AddExpensesState>(
      'emits error when usecase fails',
      build: () {
        when(() => mockAddExpenseUseCase(any())).thenAnswer(
              (_) async => Left(ServerFailure('DB error')),
        );
        final b = AddExpensesBloc(mockAddExpenseUseCase);
        b.validatorOverride = () => true;
        return b;
      },
      act: (b) {
        b.add(const SelectCategoryEvent(testCategory));
        b.add(const SelectEntryTypeEvent(EntryType.expense));
        b.amountController.text = '50';
        b.add(const SaveExpenseEvent());
      },
      expect: () => [
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
        isA<AddExpensesState>(),
      ],
      verify: (b) {
        final state = b.state;
        print('Selected: ${state.selectedCategory?.name}');
       },
    );
  });
}
