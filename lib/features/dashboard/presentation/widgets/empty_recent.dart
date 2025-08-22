import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

class EmptyRecent extends StatelessWidget {
  const EmptyRecent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 48.sp,
            color: AppColors.textDark.withOpacity(0.35),
          ),
          12.h.verticalSpace,
          Text(
            LocaleKeys.no_expenses_yet.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textDark.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
          6.h.verticalSpace,
          Text(
            LocaleKeys.recent_expenses_info.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textDark.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}
