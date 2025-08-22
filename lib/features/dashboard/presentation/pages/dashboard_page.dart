import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../add_expenses/domain/entities/expense_entity.dart';
import '../manager/dashboard_bloc.dart';
import '../manager/dashboard_event.dart';
import '../manager/dashboard_state.dart';
import '../widgets/balance_card_widget.dart';
import '../widgets/empty_recent.dart';
import '../widgets/header_card_widget.dart';
import '../widgets/recent_item_tile.dart';
import '../widgets/recent_loading_list.dart';
import '../widgets/see_more_card.dart';
import 'expenses_details_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashBloc = getIt<DashboardBloc>()..add(InitDashboardEvent());

    return BlocProvider.value(
      value: dashBloc,
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final bloc = context.read<DashboardBloc>();

          final recent = state.recent.cast<ExpenseEntity>();
          final hasMore = recent.length > 5;
          final displayCount = hasMore ? 5 : recent.length;

          final double headerHeight = 260.h;
          final double cardHeight = 189.h;
          const double outsideFraction = 0.30;
          final double insideHeight = cardHeight * (1 - outsideFraction);
          final double cardTop = headerHeight - insideHeight;
          final double headerBlockHeight =
              headerHeight + cardHeight * outsideFraction + 8.h;

          return Scaffold(
            backgroundColor: AppColors.pageBackground,
            body: RefreshIndicator.adaptive(
              onRefresh: () async {
                bloc.add(RefreshEvent());
                await Future.delayed(const Duration(milliseconds: 250));
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: headerBlockHeight,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          height: headerHeight,
                          child: HeaderTop(
                            userName: state.userName,
                            avatarUrl: state.avatarUrl,
                            period: state.period,
                            onPeriodTap: (value) {
                              bloc.add(ChangePeriodEvent(value));
                            },
                          ),
                        ),

                        Positioned(
                          left: 14.w,
                          right: 14.w,
                          top: cardTop,
                          child: SizedBox(
                            height: cardHeight,
                            child: BalanceCard(
                              total: state.stats.total,
                              income: state.stats.income,
                              expenses: state.stats.expenses,
                              loading: state.loading,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Row(
                      children: [
                        Text(
                          LocaleKeys.recent_expenses.tr(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => context.push(
                            AppRoutes.recentExpenses,
                            extra: bloc,
                          ),
                          child: Text(
                            LocaleKeys.see_all.tr(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (state.loading && recent.isEmpty) ...[
                    const RecentLoadingList(itemCount: 5),
                  ] else if (recent.isEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
                      child: const EmptyRecent(),
                    ),
                  ] else ...[
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 12.h,
                      ),
                      itemCount: displayCount,
                      separatorBuilder: (_, __) => 12.h.verticalSpace,
                      itemBuilder: (context, i) {
                        final entity = recent[i];

                        return InkWell(
                          borderRadius: BorderRadius.circular(14.r),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExpenseDetailsPage(
                                  expense: entity,
                                  allExpenses: recent,
                                  onEdit: () {
                                    Navigator.pop(context);
                                    context.push(AppRoutes.addExpense);
                                  },
                                  onDelete: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                          child: RecentItemTile(
                            title: entity.category,
                            subtitle: entity.amount >= 0
                                ? LocaleKeys.income.tr()
                                : LocaleKeys.expense.tr(),
                            amount: entity.amount,
                            time: entity.date,
                            colorSeed: entity.category.hashCode,
                          ),
                        );
                      },
                    ),
                    if (hasMore)
                      Padding(
                        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
                        child: SeeMoreCard(
                          label: LocaleKeys.see_more
                              .tr(args: ['${recent.length - displayCount}']),
                          onTap: () => context.push(
                            AppRoutes.recentExpenses,
                            extra: bloc,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),

            floatingActionButton: GestureDetector(
              onTap: () async {
                await context.push(AppRoutes.addExpense);
                bloc.loadRecent(setLoading: true);
              },
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
