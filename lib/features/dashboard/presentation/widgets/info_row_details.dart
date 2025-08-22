import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class InfoRowDetails extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final double valueOpacity;

  const InfoRowDetails({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueOpacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.textDark.withOpacity(.06),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18.r, color: AppColors.textDark.withOpacity(.7)),
        ),
        12.w.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodySmall?.copyWith(
                  color: AppColors.textDark.withOpacity(.65),
                  fontWeight: FontWeight.w600,
                ),
              ),
              4.h.verticalSpace,
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.titleSmall?.copyWith(
                  color: (valueColor ?? AppColors.textDark).withOpacity(valueOpacity),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
