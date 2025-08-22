import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/greeding_service.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';

class HeaderTop extends StatelessWidget {
  final String userName;
  final String? avatarUrl;
  final String period;
  final ValueChanged<String> onPeriodTap;

  const HeaderTop({
    super.key,
    required this.userName,
    required this.avatarUrl,
    required this.period,
    required this.onPeriodTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 52.h, right: 4.w, bottom: 16.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 23.r,
              backgroundImage: const AssetImage('assets/images/avatar_placeholder.jpg'),
            ),

            10.w.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GreetingService.getGreeting(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white.withOpacity(.9)),
                ),
                Text(
                  userName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const Spacer(),
            PopupMenuButton<String>(
              onSelected: (value) {
                onPeriodTap(value);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: LocaleKeys.this_month.tr(),
                  child: Text(
                    LocaleKeys.this_month.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: LocaleKeys.last_7_days.tr(),
                  child: Text(
                    LocaleKeys.last_7_days.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              offset: Offset(0, 44.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              color: Colors.white,
              elevation: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      period,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.sp,
                      ),
                    ),
                    6.w.horizontalSpace,
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
