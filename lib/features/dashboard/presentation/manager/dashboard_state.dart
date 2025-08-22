// lib/features/dashboard/presentation/manager/dashboard_state.dart
import 'package:expense_tracker/features/add_expenses/domain/entities/expense_entity.dart';

class DashboardState {
  final bool loading;
  final bool refreshing;
  final String period;

  final DashboardStats stats;

  /// Full dataset (now entities)
  final List<ExpenseEntity> recent;

  /// Visible page (now entities)
  final List<ExpenseEntity> recentVisible;

  final int recentNextIndex;
  final int recentPageSize;
  final bool recentHasMore;
  final bool recentLoadingMore;

  final String? error;
  final bool balanceVisible;
  final String userName;
  final String? avatarUrl;

  const DashboardState({
    this.loading = false,
    this.refreshing = false,
    this.period = 'This Month',
    this.stats = const DashboardStats(),
    this.recent = const [],
    this.recentVisible = const [],
    this.recentNextIndex = 0,
    this.recentPageSize = 10,
    this.recentHasMore = false,
    this.recentLoadingMore = false,
    this.error,
    this.userName = 'Guest',
    this.avatarUrl,
    this.balanceVisible = true,
  });

  DashboardState copyWith({
    bool? loading,
    bool? refreshing,
    String? period,
    DashboardStats? stats,
    List<ExpenseEntity>? recent,
    List<ExpenseEntity>? recentVisible,
    int? recentNextIndex,
    int? recentPageSize,
    bool? recentHasMore,
    bool? recentLoadingMore,
    String? error,
    String? userName,
    String? avatarUrl,
    bool? balanceVisible,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      period: period ?? this.period,
      stats: stats ?? this.stats,
      recent: recent ?? this.recent,
      recentVisible: recentVisible ?? this.recentVisible,
      recentNextIndex: recentNextIndex ?? this.recentNextIndex,
      recentPageSize: recentPageSize ?? this.recentPageSize,
      recentHasMore: recentHasMore ?? this.recentHasMore,
      recentLoadingMore: recentLoadingMore ?? this.recentLoadingMore,
      error: error,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      balanceVisible: balanceVisible ?? this.balanceVisible,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DashboardState &&
              loading == other.loading &&
              refreshing == other.refreshing &&
              period == other.period &&
              stats == other.stats &&
              _listEquals(recent, other.recent) &&
              _listEquals(recentVisible, other.recentVisible) &&
              recentNextIndex == other.recentNextIndex &&
              recentPageSize == other.recentPageSize &&
              recentHasMore == other.recentHasMore &&
              recentLoadingMore == other.recentLoadingMore &&
              error == other.error &&
              userName == other.userName &&
              avatarUrl == other.avatarUrl &&
              balanceVisible == other.balanceVisible;

  @override
  int get hashCode => Object.hash(
    loading,
    refreshing,
    period,
    stats,
    Object.hashAll(recent),
    Object.hashAll(recentVisible),
    recentNextIndex,
    recentPageSize,
    recentHasMore,
    recentLoadingMore,
    error,
    userName,
    avatarUrl,
    balanceVisible,
  );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class DashboardStats {
  final double total;
  final double income;
  final double expenses;

  const DashboardStats({
    this.total = 0,
    this.income = 0,
    this.expenses = 0,
  });

  DashboardStats copyWith({
    double? total,
    double? income,
    double? expenses,
  }) {
    return DashboardStats(
      total: total ?? this.total,
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DashboardStats &&
              total == other.total &&
              income == other.income &&
              expenses == other.expenses;

  @override
  int get hashCode => Object.hash(total, income, expenses);
}
