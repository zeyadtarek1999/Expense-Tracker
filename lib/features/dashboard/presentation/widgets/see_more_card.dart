import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';

class SeeMoreCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SeeMoreCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryBlue, width: 1),
          foregroundColor: AppColors.primaryBlue,
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ).copyWith(
          overlayColor: WidgetStatePropertyAll(AppColors.primaryBlue.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  letterSpacing: 0.2,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
