import 'package:easy_localization/easy_localization.dart';
 import 'package:expense_tracker/features/dashboard/presentation/widgets/recent_loading_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:printing/printing.dart';

import '../../../../core/services/pdf_export_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/expenses_util.dart';
import '../../../../shared_widgets/custom_app_bar.dart';
import '../../../add_expenses/domain/entities/expense_entity.dart';
import '../manager/dashboard_bloc.dart';
import '../manager/dashboard_event.dart';
import '../manager/dashboard_state.dart';
import '../widgets/recent_item_tile.dart';
import '../widgets/stats_slider.dart';
import 'expenses_details_page.dart';
import '../../../../generated/locale_keys.g.dart';

class RecentExpensesScreen extends StatelessWidget {
  const RecentExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: CustomAppBar(title: LocaleKeys.recent_expenses.tr()),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final List<ExpenseEntity> all = state.recent.cast<ExpenseEntity>();
          final List<ExpenseEntity> visible = state.recentVisible.cast<ExpenseEntity>();

          if (state.loading && visible.isEmpty) {
            return const RecentLoadingList(itemCount: 5);
          }

          if (all.isEmpty) {
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  LocaleKeys.no_expenses.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final totalExpenses = ExpenseUtils.totalExpenses(all);
          final totalIncome = ExpenseUtils.totalIncome(all);
          final expenseCount = all.where((e) => e.amount < 0).length;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              children: [
                12.h.verticalSpace,
                StatsSlider(
                  totalIncome: totalIncome,
                  incomeCount: all.where((e) => e.amount > 0).length,
                  totalExpenses: totalExpenses,
                  expenseCount: expenseCount,
                ),
                12.h.verticalSpace,
                Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: () async {
                      context.read<DashboardBloc>().add(RefreshEvent());
                    },
                    child: LazyLoadScrollView(
                      onEndOfPage: () {
                        if (state.recentHasMore && !state.recentLoadingMore) {
                          context.read<DashboardBloc>().add(LoadMoreRecentEvent());
                        }
                      },
                      child: ListView.separated(
                        itemCount: visible.length + (state.recentLoadingMore ? 1 : 0),
                        separatorBuilder: (_, __) => 12.h.verticalSpace,
                        itemBuilder: (context, i) {
                          if (i == visible.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                            );
                          }

                          final item = visible[i];

                          void openDetails() {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ExpenseDetailsPage(
                                  expense: item,
                                  allExpenses: all,
                                ),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: openDetails,
                            child: RecentItemTile(
                              title: item.category,
                              subtitle: item.amount >= 0 ? LocaleKeys.income.tr() : LocaleKeys.expense.tr(),
                              amount: item.amount,
                              time: item.date,
                              colorSeed: item.category.hashCode,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final List<ExpenseEntity> all = state.recent.cast<ExpenseEntity>();
          if (all.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            backgroundColor: AppColors.primaryBlue,
            icon: const Icon(Icons.download, color: Colors.white),
            label: Text(LocaleKeys.summary.tr(),
                style: const TextStyle(color: Colors.white)),
            onPressed: () async {
              final file = await PdfExportService.generateReport(expenses: all);
              await Printing.sharePdf(
                bytes: await file.readAsBytes(),
                filename: "expenses_report.pdf",
              );
            },
          );
        },
      ),
    );
  }
}
