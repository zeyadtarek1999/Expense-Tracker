 import 'package:expense_tracker/features/currancy_conversion/presentation/widgets/search_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';

class SearchableDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const SearchableDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedText = value ?? 'Select';
    return InkWell(
      borderRadius: BorderRadius.circular(11.r),
      onTap: () => _openPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.r),
          color: AppColors.white,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMedium,
                      )),
                  4.h.verticalSpace,
                  Text(
                    selectedText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDark),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final res = await SearchPickerBottomSheet.show(
      context,
      title: label,
      items: items,
      initial: value,
      quickPicks: const ['USD', 'EUR', 'EGP', 'GBP', 'AED'],
    );
    if (res != null) onChanged(res);
  }
}
