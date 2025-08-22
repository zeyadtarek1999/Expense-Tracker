// lib/features/dashboard/presentation/widgets/recent_item_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';

class RecentItemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;  /// negative = expense, positive = income
  final DateTime time;
  final int colorSeed;

  const RecentItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.colorSeed,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = amount < 0;
    final tint = _categoryTint(colorSeed);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: tint.withOpacity(.18),
          child: Icon(Icons.shopping_cart_outlined, color: tint),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme
              .of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme
              .of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black.withOpacity(.45)),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isNegative ? '-' : '+'} \$${amount.abs().toStringAsFixed(0)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color: isNegative ? Colors.black87 : AppColors.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
            4.h.verticalSpace,
            Text(
              TimeFormatter.formatToday12h(time),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black.withOpacity(.45)),
            ),
          ],
        ),
      ),
    );
  }
}


Color _categoryTint(int id) {
  switch (id % 6) {
    case 0:
      return AppColors.groceries;
    case 1:
      return AppColors.entertainment;
    case 2:
      return AppColors.transport;
    case 3:
      return AppColors.rent;
    case 4:
      return AppColors.gas;
    default:
      return AppColors.shopping;
  }
}

