import 'package:expense_tracker/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  const CustomElevatedButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.gradient,
    this.disabledGradient,
    this.borderRadius,
    this.loadingColor = Colors.white,
    this.leading,
    this.trailing,
    this.padding,
    this.semanticLabel,
  });

  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final Gradient? gradient;
  final Gradient? disabledGradient;
  final double? borderRadius;
  final Color loadingColor;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular((borderRadius ?? 14).r);
    final disabled = isDisabled || isLoading;

    return Semantics(
      button: true,
      label: semanticLabel ?? text,
      enabled: !disabled,
      child: SizedBox(
        width: width ?? 1.sw,
        height: height ?? 48.h,
        child: Material(
          color: Colors.transparent,
          borderRadius: br,
          child: Ink(
            decoration: BoxDecoration(
              color: disabled ? Colors.grey : AppColors.primaryBlue,
              borderRadius: br,
            ),
            child: InkWell(
              onTap: disabled ? null : onPressed,
              borderRadius: br,
              child: Padding(
                padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4.w,
                      valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[
                        SizedBox(height: 20.h, child: Center(child: leading)),
                        8.horizontalSpace,
                      ],
                      Text(
                        text,
                        style: textStyle ??
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (trailing != null) ...[
                        8.horizontalSpace,
                        SizedBox(height: 20.h, child: Center(child: trailing)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
