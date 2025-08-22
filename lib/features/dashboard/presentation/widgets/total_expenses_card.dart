import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/expenses_util.dart';
import '../../../../generated/locale_keys.g.dart';

class TotalExpensesCard extends StatelessWidget {
  final double total;
  final int count;

  const TotalExpensesCard({
    super.key,
    required this.total,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const blue = AppColors.primaryBlue;

    final transactionText = count == 1
        ? LocaleKeys.transaction_singular.tr()
        : LocaleKeys.transaction_plural.tr();

    return Container(
      decoration: BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: blue.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
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
                color: Colors.white.withOpacity(0.18),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.trending_down_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            12.w.horizontalSpace,
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.total_expenses.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.92),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    4.h.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$count $transactionText',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            8.w.horizontalSpace,
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                ExpenseUtils.formatAmount(total),
                textAlign: TextAlign.right,
                style: text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
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
