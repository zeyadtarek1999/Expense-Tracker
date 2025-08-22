import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';

class RecentLoadingList extends StatelessWidget {
  final int itemCount;

  const RecentLoadingList({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
      itemCount: itemCount,
      separatorBuilder: (_, __) => 12.h.verticalSpace,
      itemBuilder: (_, __) => _buildSkeletonTile(),
    );
  }

  Widget _buildSkeletonTile() {
    return Container(
      height: 72.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // circular placeholder
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.textDark.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
          ),
          12.w.horizontalSpace,
          // text placeholders
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bar(width: 140.w, height: 12.h),
                8.h.verticalSpace,
                Row(
                  children: [
                    _bar(width: 80.w, height: 10.h),
                    8.w.horizontalSpace,
                    _dot(),
                    8.w.horizontalSpace,
                    _bar(width: 60.w, height: 10.h),
                  ],
                ),
              ],
            ),
          ),
          12.w.horizontalSpace,
          _bar(width: 52.w, height: 14.h),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.textDark.withOpacity(0.06),
        borderRadius: BorderRadius.circular(6.r),
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 6.w,
      height: 6.w,
      decoration: BoxDecoration(
        color: AppColors.textDark.withOpacity(0.10),
        shape: BoxShape.circle,
      ),
    );
  }
}
