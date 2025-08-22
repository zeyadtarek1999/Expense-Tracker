import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../manager/add_expenses_bloc.dart' ;

class TypeSelectorWidget extends StatelessWidget {
  final EntryType entryType;
  final ValueChanged<EntryType> onChanged;

  const TypeSelectorWidget({
    super.key,
    required this.entryType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = entryType == EntryType.income;

    return Row(
      children: [
        Expanded(
          child: _Choice(
            label: 'Expense',
            selected: !isIncome,
            icon: Icons.remove_circle_outline,
            onTap: () => onChanged(EntryType.expense),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _Choice(
            label: 'Income',
            selected: isIncome,
            icon: Icons.add_circle_outline,
            onTap: () => onChanged(EntryType.income),
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  const _Choice({
    Key? key,
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryBlue.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: selected ? AppColors.primaryBlue : Colors.black12,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18.sp,
                  color: selected ? AppColors.primaryBlue : AppColors.textDark.withOpacity(0.7),
                ),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.primaryBlue : AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
