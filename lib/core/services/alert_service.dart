import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../shared_widgets/custom_text.dart';
import '../enum/alert_enum.dart';
import '../utils/app_colors.dart';

class AlertService {
  final FToast _fToast = FToast();

  void showAlert({
    required BuildContext context,
    required String title,
    required String subtitle,
    required AlertStatus status,
  }) {
    _fToast.init(context);

    final bool isSuccess = status == AlertStatus.success;
    final Color base = isSuccess ? AppColors.green : AppColors.error;
    final Color bg = AppColors.white;
    final Color border = base;
    final Color iconBg = base.withOpacity(.12);
    final Color iconColor = base;

    _fToast.removeQueuedCustomToasts();

    _fToast.showToast(
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
      child: Container(
        width: 350.w,
        constraints: BoxConstraints(maxHeight: 120.h),
        padding: EdgeInsets.all(12.w),
        margin: EdgeInsets.only(bottom: 20.w),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_rounded : Icons.error_rounded,
                color: iconColor,
                size: 22.w,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: title,
                    maxLines: 2,
                    textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  4.verticalSpace,
                  CustomTextWidget(
                    text: subtitle,
                    maxLines: 3,
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => _fToast.removeCustomToast(),
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.close_rounded, size: 20.w, color: AppColors.textMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
