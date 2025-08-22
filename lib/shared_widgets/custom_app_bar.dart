import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onPdfExport;
  final bool showBack;
  final bool showPdf;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.onPdfExport,
    this.showBack = true,
    this.showPdf = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        color: AppColors.pageBackground,
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showBack)
              Align(
                alignment:
                isRtl ? Alignment.centerRight : Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack ?? () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 20.sp,
                    color: AppColors.textDark,
                  ),
                ),
              ),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56.w),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp,
                  color: AppColors.textDark,
                ),
              ),
            ),

            if (showPdf)
              Align(
                 alignment:
                isRtl ? Alignment.centerLeft : Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    color: AppColors.primaryBlue,
                  ),
                  onPressed: onPdfExport,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 16.h);
}
