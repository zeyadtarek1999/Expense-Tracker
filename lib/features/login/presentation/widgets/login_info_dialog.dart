 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared_widgets/buttons/elevated_btn_widget.dart';

class InfoDialogWidget extends StatelessWidget {
  const InfoDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        'Info',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.textTheme.headlineSmall?.color,
        ),
      ),
      content: Text(
        'You can enter any email and password to simulate a login.',
        style: theme.textTheme.bodyMedium,
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      actions: [
        CustomElevatedButtonWidget(
          text: 'OK',
          onPressed: () => Navigator.of(context).pop(),
          height: 40.h,
          width: 100.w,
          textStyle: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
          borderRadius: 10.r,
          loadingColor: Colors.white,
          isLoading: false,
          isDisabled: false,
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      contentPadding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
    );
  }
}
