import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import 'expenses_form_widget.dart';

class CategoryDropdown extends StatelessWidget {
  final List<Category> categories;
  final Category? value;
  final ValueChanged<Category> onChanged;
  final String hint;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.value,
    required this.onChanged,
    this.hint = 'Select category',
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return DropdownButtonFormField<Category>(
      value: value,
      isExpanded: true,
      borderRadius: BorderRadius.circular(12.r),
      menuMaxHeight: 320.h,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18.sp,
        color: AppColors.primaryBlue,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1),

        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
      ),
      dropdownColor: Colors.white,
      style: text.titleMedium?.copyWith(
        color: AppColors.textDark,
        fontWeight: FontWeight.w700,
      ),
      hint: Text(
        hint,
        style: text.bodyMedium?.copyWith(
          color: AppColors.textDark.withOpacity(0.55),
          fontWeight: FontWeight.w600,
        ),
      ),
      items: categories
          .map(
            (c) => DropdownMenuItem<Category>(
          value: c,
          child: _CategoryTile(category: c),
        ),
      )
          .toList(),
      selectedItemBuilder: (_) => categories
          .map(
            (c) => Align(
          alignment: Alignment.centerLeft,
          child: _CategoryTile(category: c),
        ),
      )
          .toList(),
      onChanged: (c) {
        if (c != null) onChanged(c);
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final Category category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(category.icon, size: 22.sp, color: category.color),
        10.w.horizontalSpace,
        Flexible(
          child: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.bodyLarge?.copyWith(
              color: AppColors.textDark,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}
