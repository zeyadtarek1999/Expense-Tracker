import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:expense_tracker/injection_container.dart';
import 'package:expense_tracker/core/app_constants/arg_keys.dart';

import '../../core/helpers/shared_prefrences.dart';
import '../../features/add_expenses/presentation/pages/add_expenses_page.dart';
import '../../features/dashboard/presentation/manager/dashboard_bloc.dart';
import '../../features/dashboard/presentation/manager/dashboard_event.dart';
import '../../features/dashboard/presentation/pages/recent_expenses_page.dart';
import '../../features/home_layout/presentation/pages/home_layout_page.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';
import '../../features/login/presentation/pages/login_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String homeLayout = '/home';
  static const String addExpense = '/add-expense';
  static const String recentExpenses = '/recent-expenses';

   static GoRouter buildRouter() {
    final cache = getIt<CacheHelper>();

    bool isLoggedIn() =>
        (cache.getData(key: AppArgKey.isLoggedIn) as bool?) ?? false;

    return GoRouter(
      initialLocation: isLoggedIn() ? homeLayout : login,
      redirect: (context, state) {
        final loggedIn = isLoggedIn();
        final goingToLogin = state.matchedLocation == login;

        if (!loggedIn && !goingToLogin) return login;
        if (loggedIn && goingToLogin) return homeLayout;
        return null;
      },
      routes: [
        GoRoute(
          path: login,
          pageBuilder: (context, state) => _buildTransitionPage(
            state,
            BlocProvider(
              create: (_) => getIt<LoginBloc>()..add(InitLoginEvent()),
              child: const LoginPage(),
            ),
          ),
        ),
        GoRoute(
          path: homeLayout,
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, const HomeLayoutPage()),
        ),
        GoRoute(
          path: addExpense,
          pageBuilder: (context, state) =>
              _buildTransitionPage(state, AddExpensePage()),
        ),
        GoRoute(
          path: recentExpenses,
          pageBuilder: (context, state) {
            final DashboardBloc? bloc =
            state.extra is DashboardBloc ? state.extra as DashboardBloc : null;

            final child = bloc == null
                ? BlocProvider(
              create: (_) =>
              getIt<DashboardBloc>()..add(InitDashboardEvent()),
              child: const RecentExpensesScreen(),
            )
                : BlocProvider.value(
              value: bloc,
              child: const RecentExpensesScreen(),
            );

            return _buildTransitionPage(state, child);
          },
        ),
      ],
    );
  }

  static CustomTransitionPage _buildTransitionPage(
      GoRouterState state,
      Widget child,
      ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0.8, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: animation.drive(offsetTween), child: child);
      },
    );
  }
}
