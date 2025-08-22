// lib/features/dashboard/presentation/manager/dashboard_event.dart
abstract class DashboardEvent {}

class InitDashboardEvent extends DashboardEvent {}
class RefreshEvent extends DashboardEvent {}
class ChangePeriodEvent extends DashboardEvent {
  final String period;
  ChangePeriodEvent(this.period);
}
class AddExpensePressed extends DashboardEvent {}
class AddExpenseEvent extends DashboardEvent {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime time;
  final int categorySeed;
  AddExpenseEvent({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.categorySeed,
  });
}
class ToggleBalanceVisibilityEvent extends DashboardEvent {}
class LoadMoreRecentEvent extends DashboardEvent {}

 class ReloadRecentEvent extends DashboardEvent {
  final bool setLoading;
  final bool setRefreshing;
  final String? userName;
  final String? avatarUrl;
    ReloadRecentEvent({
    this.setLoading = true,
    this.setRefreshing = false,
    this.userName,
    this.avatarUrl,
  });
}
