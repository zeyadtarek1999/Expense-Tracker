import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/expenses_util.dart';
import '../../../../generated/locale_keys.g.dart';

class TotalIncomeCard extends StatelessWidget {
  final double total;
  final int count;

  const TotalIncomeCard({
    super.key,
    required this.total,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final transactionText = count == 1
        ? LocaleKeys.transaction_singular.tr()
        : LocaleKeys.transaction_plural.tr();

    return Container(
      constraints: BoxConstraints(minHeight: 90.h),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.green.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.18),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.trending_up_rounded,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.total_income.tr(),
                        style: text.titleMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.92),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '$count $transactionText',
                          style: text.bodySmall?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                ExpenseUtils.formatAmount(total),
                textAlign: TextAlign.right,
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
