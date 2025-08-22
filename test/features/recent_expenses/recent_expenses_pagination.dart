 import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/dashboard/presentation/manager/dashboard_bloc.dart';
import 'package:expense_tracker/features/dashboard/presentation/manager/dashboard_event.dart';
import 'package:expense_tracker/features/dashboard/presentation/manager/dashboard_state.dart';
import 'package:expense_tracker/features/dashboard/presentation/pages/recent_expenses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardBloc extends MockBloc<DashboardEvent, DashboardState>
    implements DashboardBloc {}

class FakeDashboardEvent extends Fake implements DashboardEvent {}
class FakeDashboardState extends Fake implements DashboardState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDashboardEvent());
    registerFallbackValue(FakeDashboardState());
  });

  ExpenseEntity e(int i, {double amount = -10.0}) => ExpenseEntity(
    category: 'Cat $i',
    amount: amount,
    date: DateTime(2024, 1, 1).add(Duration(days: i)),
    receipt: null,
  );

  DashboardState baseState({
    required List<ExpenseEntity> all,
    required List<ExpenseEntity> visible,
    bool loading = false,
    bool recentHasMore = false,
    bool recentLoadingMore = false,
  }) {
    return DashboardState(
      loading: loading,
      recent: all,
      recentVisible: visible,
      recentHasMore: recentHasMore,
      recentLoadingMore: recentLoadingMore,
    );
  }

  Future<void> pumpRecent(
      WidgetTester tester,
      DashboardBloc bloc,
      DashboardState state,
      ) async {
    when(() => bloc.state).thenReturn(state);
    whenListen(
      bloc,
      Stream<DashboardState>.fromIterable([state]),
      initialState: state,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1200, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(1200, 800)),
            child: BlocProvider.value(
              value: bloc,
              child: const RecentExpensesScreen(),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('RecentExpensesScreen pagination', () {
    testWidgets(
      'dispatches LoadMoreRecentEvent when end reached and hasMore == true',
          (tester) async {
        print('Running: dispatch load more when hasMore');

        final bloc = MockDashboardBloc();
        final all = List.generate(30, (i) => e(i));
        final visible = all.take(10).toList();

        final state = baseState(
          all: all,
          visible: visible,
          loading: false,
          recentHasMore: true,
          recentLoadingMore: false,
        );

        await pumpRecent(tester, bloc, state);

        expect(find.byType(LazyLoadScrollView), findsOneWidget);
        final lazy = tester.widget<LazyLoadScrollView>(
          find.byType(LazyLoadScrollView),
        );

        lazy.onEndOfPage?.call();
        await tester.pump();

        verify(() => bloc.add(any(that: isA<LoadMoreRecentEvent>()))).called(1);
        print('Verified: LoadMoreRecentEvent dispatched');
      },
    );

    testWidgets(
      'does NOT dispatch LoadMoreRecentEvent when hasMore == false',
          (tester) async {
        print('Running: no dispatch when hasMore == false');

        final bloc = MockDashboardBloc();
        final all = List.generate(15, (i) => e(i));
        final visible = all;

        final state = baseState(
          all: all,
          visible: visible,
          loading: false,
          recentHasMore: false,
          recentLoadingMore: false,
        );

        await pumpRecent(tester, bloc, state);

        expect(find.byType(LazyLoadScrollView), findsOneWidget);
        final lazy = tester.widget<LazyLoadScrollView>(
          find.byType(LazyLoadScrollView),
        );

        lazy.onEndOfPage?.call();
        await tester.pump();

        verifyNever(() => bloc.add(any(that: isA<LoadMoreRecentEvent>())));
        print('Verified: LoadMoreRecentEvent NOT dispatched');
      },
    );

    testWidgets(
      'shows bottom loading indicator item when recentLoadingMore == true',
          (tester) async {
        print('Running: shows bottom loading indicator');

        final bloc = MockDashboardBloc();
        final all = List.generate(12, (i) => e(i));
        final visible = all.take(10).toList();

        final state = baseState(
          all: all,
          visible: visible,
          loading: false,
          recentHasMore: true,
          recentLoadingMore: true,
        );

        await pumpRecent(tester, bloc, state);

         final listFinder = find.byType(ListView);
        expect(listFinder, findsOneWidget);
        await tester.drag(listFinder, const Offset(0, -5000));

             await tester.pump();
            await tester.pump(const Duration(milliseconds: 400));

            expect(find.byType(CircularProgressIndicator), findsOneWidget);


            expect(find.byType(CircularProgressIndicator), findsOneWidget);
        print('Verified: CircularProgressIndicator visible at bottom');
      },
    );

  });
}
