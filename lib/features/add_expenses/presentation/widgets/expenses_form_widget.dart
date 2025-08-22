import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class CustomFormWidgets {
   static Widget selectorField({
    required String hint,
    required String? valueText,
    required VoidCallback onTap,
  }) {
    final text = valueText ?? hint;
    final isHint = valueText == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isHint ? AppColors.hint : AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  /// Field Label
  static Widget fieldLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

   static Widget categoryChip({
    required Category category,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final bg = selected ? category.color.withOpacity(.12) : AppColors.lightBackground;
    final iconColor = selected ? category.color : Colors.black45;
    final textColor = selected ? AppColors.primaryBlue : AppColors.textMedium;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: (1.sw - 16.w * 2 - 18.w * 3) / 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? category.color.withOpacity(.35) : Colors.transparent,
                ),
              ),
              child: Icon(category.icon, color: iconColor, size: 26.r),
            ),
            SizedBox(height: 8.h),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                color: textColor,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 class Category {
  final String name;
  final IconData icon;
  final Color color;
  const Category(this.name, this.icon, this.color);
}
