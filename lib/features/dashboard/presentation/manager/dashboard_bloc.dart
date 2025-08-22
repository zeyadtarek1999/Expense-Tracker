// lib/features/dashboard/presentation/manager/dashboard_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';
import 'package:expense_tracker/features/add_expenses/domain/use_cases/get_recent_expenses_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetRecentExpensesUseCase getRecentExpenses;

  DashboardBloc(this.getRecentExpenses) : super(const DashboardState()) {
    on<InitDashboardEvent>(_onInit);
    on<RefreshEvent>(_onRefresh);
    on<ChangePeriodEvent>(_onChangePeriod);
    on<AddExpensePressed>(_onAddExpensePressed);
    on<AddExpenseEvent>(_onAddExpense);
    on<ToggleBalanceVisibilityEvent>(_onToggleBalanceVisibility);
    on<LoadMoreRecentEvent>(_onLoadMoreRecent);
    on<ReloadRecentEvent>(_onReloadRecent);
  }

  void loadRecent({
    bool setLoading = true,
    bool setRefreshing = false,
    String? userName,
    String? avatarUrl,
  }) {
    add(ReloadRecentEvent(
      setLoading: setLoading,
      setRefreshing: setRefreshing,
      userName: userName,
      avatarUrl: avatarUrl,
    ));
  }

  Future<void> _onInit(InitDashboardEvent event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(loading: true, error: null));
    final (name, avatar) = await _fetchUserProfile();
    await _performLoadRecent(
      emit,
      userName: name,
      avatarUrl: avatar,
      setLoading: false,
    );
  }

  Future<void> _onRefresh(RefreshEvent event, Emitter<DashboardState> emit) async {
    await _performLoadRecent(emit, setRefreshing: true);
  }

  Future<void> _onChangePeriod(ChangePeriodEvent event, Emitter<DashboardState> emit) async {
    emit(state.copyWith(period: event.period, loading: true, error: null));
    await _performLoadRecent(emit, setLoading: false);
  }

  Future<void> _onReloadRecent(ReloadRecentEvent event, Emitter<DashboardState> emit) async {
    await _performLoadRecent(
      emit,
      userName: event.userName,
      avatarUrl: event.avatarUrl,
      setLoading: event.setLoading,
      setRefreshing: event.setRefreshing,
    );
  }

  void _onAddExpensePressed(AddExpensePressed event, Emitter<DashboardState> emit) {}

  // Keep this for optimistic UI insertions, now using ExpenseEntity
  void _onAddExpense(AddExpenseEvent event, Emitter<DashboardState> emit) {
    final inserted = ExpenseEntity(
      category: event.title,
      amount: event.amount,
      date: event.time,
      receipt: null,
    );

    final updatedRecent = [inserted, ...state.recent]..sort((a, b) => b.date.compareTo(a.date));
    final currentVisibleCount = state.recentVisible.length;
    final newVisible = updatedRecent.take(max(currentVisibleCount, 0)).toList();
    final newStats = _computeStats(updatedRecent);

    emit(
      state.copyWith(
        stats: newStats,
        recent: updatedRecent,
        recentVisible: newVisible,
        recentNextIndex: max(currentVisibleCount, 0),
        recentHasMore: updatedRecent.length > newVisible.length,
      ),
    );
  }

  void _onToggleBalanceVisibility(ToggleBalanceVisibilityEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(balanceVisible: !state.balanceVisible));
  }

  Future<void> _onLoadMoreRecent(LoadMoreRecentEvent event, Emitter<DashboardState> emit) async {
    if (!state.recentHasMore || state.recentLoadingMore) return;
    emit(state.copyWith(recentLoadingMore: true));
    await Future.delayed(const Duration(milliseconds: 450));
    final start = state.recentNextIndex;
    final end = min(start + state.recentPageSize, state.recent.length);
    if (start >= end) {
      emit(state.copyWith(recentLoadingMore: false, recentHasMore: false));
      return;
    }
    final more = state.recent.sublist(start, end);
    final updatedVisible = List<ExpenseEntity>.from(state.recentVisible)..addAll(more);
    emit(state.copyWith(
      recentVisible: updatedVisible,
      recentNextIndex: end,
      recentHasMore: end < state.recent.length,
      recentLoadingMore: false,
    ));
  }

  Future<(String, String?)> _fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ('Shihab Rahman', 'assets/images/avatar_placeholder.jpg');
  }

  Future<void> _performLoadRecent(
      Emitter<DashboardState> emit, {
        String? userName,
        String? avatarUrl,
        bool setLoading = true,
        bool setRefreshing = false,
      }) async {
    if (setLoading) emit(state.copyWith(loading: true, error: null));
    if (setRefreshing) emit(state.copyWith(refreshing: true, error: null));

    final recentEither = await getRecentExpenses(GetRecentParams(limit: 200));

    await recentEither.fold(
          (failure) async {
        emit(state.copyWith(
          loading: false,
          refreshing: false,
          userName: userName ?? state.userName,
          avatarUrl: avatarUrl ?? state.avatarUrl,
          error: failure.massage,
        ));
      },
          (entities) async {
        final now = DateTime.now();
        List<ExpenseEntity> filtered = [...entities];

        if (state.period == "This Month") {
          filtered = filtered.where((e) =>
          e.date.year == now.year && e.date.month == now.month
          ).toList();
        } else if (state.period == "Last 7 Days") {
          final cutoff = now.subtract(const Duration(days: 7));
          filtered = filtered.where((e) => e.date.isAfter(cutoff)).toList();
        }

        filtered.sort((a, b) => b.date.compareTo(a.date));

        final stats = _computeStats(filtered);
        final pageSize = state.recentPageSize;
        final first = filtered.take(pageSize).toList();

        emit(state.copyWith(
          loading: false,
          refreshing: false,
          userName: userName ?? state.userName,
          avatarUrl: avatarUrl ?? state.avatarUrl,
          stats: stats,
          recent: filtered,
          recentVisible: first,
          recentNextIndex: first.length,
          recentHasMore: filtered.length > first.length,
          recentLoadingMore: false,
        ));
      },
    );
  }


  DashboardStats _computeStats(List<ExpenseEntity> items) {
    final income = items.where((e) => e.amount > 0).fold<double>(0, (s, e) => s + e.amount);
    final expensesAbs = items.where((e) => e.amount < 0).fold<double>(0, (s, e) => s + e.amount.abs());
    final total = income - expensesAbs;
    return state.stats.copyWith(total: total, income: income, expenses: expensesAbs);
  }
}
