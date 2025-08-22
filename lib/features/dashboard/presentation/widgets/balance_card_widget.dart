import 'package:easy_localization/easy_localization.dart';
import 'package:expense_tracker/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../manager/dashboard_bloc.dart';
import '../manager/dashboard_event.dart';
import '../manager/dashboard_state.dart';
import '../widgets/pill_stat_widget.dart';
import '../../../../generated/locale_keys.g.dart';

class BalanceCard extends StatelessWidget {
  final double total;
  final double income;
  final double expenses;
  final bool loading;

  const BalanceCard({
    super.key,
    required this.total,
    required this.income,
    required this.expenses,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColors.balanceCardBlue,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              loading
                  ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: const CircularProgressIndicator(color: Colors.white),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        LocaleKeys.total_balance.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      6.w.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          context.read<DashboardBloc>().add(ToggleBalanceVisibilityEvent());
                        },
                        child: Icon(
                          state.balanceVisible
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.more_horiz, color: Colors.white.withOpacity(.9)),
                    ],
                  ),
                  10.h.verticalSpace,
                  if (state.balanceVisible)
                    Text(
                      '\$ ${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  18.h.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        child: PillStat(
                          label: LocaleKeys.income.tr(),
                          value: income,
                          icon: Icons.arrow_downward_rounded,
                        ),
                      ),
                      12.w.horizontalSpace,
                      Expanded(
                        child: PillStat(
                          label: LocaleKeys.expenses.tr(),
                          value: expenses,
                          icon: Icons.arrow_upward_rounded,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
