 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';

class PlainDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const PlainDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11.r),
        color: AppColors.white,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        isExpanded: true,
        isDense: true,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textMedium,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 2.h),
        ),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.textDark,
          fontSize: 22.sp,
        ),
        dropdownColor: AppColors.white,
        borderRadius: BorderRadius.circular(11.r),
        menuMaxHeight: 400.h,
        items: items
            .map(
              (code) => DropdownMenuItem(
            value: code,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                code,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
