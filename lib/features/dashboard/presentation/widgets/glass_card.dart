 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final BorderRadiusGeometry? radius;
  final List<BoxShadow>? shadows;
  final BoxBorder? border;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.color,
    this.radius,
    this.shadows,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;
    return Container(
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: gradient,
        color: hasGradient ? null : (color ?? Colors.white),
        borderRadius: radius ?? BorderRadius.circular(16.r),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
        border: hasGradient ? null : (border ?? Border.all(color: Colors.black12, width: 1)),
      ),
      child: child,
    );
  }
}
