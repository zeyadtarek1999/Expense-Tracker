import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/app_colors.dart';

class CustomTextFormFieldWidget extends StatefulWidget {
  const CustomTextFormFieldWidget({
    super.key,
    required this.hint,
    this.validator,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.textInputType,
    this.textInputAction,
    this.textAlign = TextAlign.start,
    this.fillColor,
    this.hintColor,
    this.textColor,
    this.onChange,
    this.onEditingComplete,
    this.onTap,
  });

  final TextEditingController? controller;
  final String hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final bool readOnly;
  final TextAlign textAlign;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Color? fillColor;
  final Color? hintColor;
  final Color? textColor;
  final void Function(String)? onChange;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;

  @override
  State<CustomTextFormFieldWidget> createState() =>
      _CustomTextFormFieldWidgetState();
}

class _CustomTextFormFieldWidgetState
    extends State<CustomTextFormFieldWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool focused = _focusNode.hasFocus;
    final Color bg = widget.fillColor ?? AppColors.lightBackground;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: focused ? AppColors.primaryBlue : Colors.transparent,
          width: focused ? 1 : 0.4,
        ),
      ),
      child: TextFormField(
        focusNode: _focusNode,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChange,
        onEditingComplete: widget.onEditingComplete,
        onTap: widget.onTap,
        textAlign: widget.textAlign,
        textAlignVertical: TextAlignVertical.center,
        validator: widget.validator,  
        cursorColor: AppColors.primaryBlue,
        style: TextStyle(
          color: widget.textColor ?? AppColors.textDark,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          height: 1.2,
        ),
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: widget.hintColor ?? AppColors.hint,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: widget.prefixIcon == null
              ? null
              : Padding(
            padding: EdgeInsets.only(left: 4.w, right: 6.w),
            child: SizedBox(
              height: 20.w,
              width: 20.w,
              child: Center(child: widget.prefixIcon),
            ),
          ),
          prefixIconConstraints:
          BoxConstraints(minHeight: 20.w, minWidth: 20.w),
          suffixIcon: widget.suffixIcon == null
              ? null
              : Padding(
            padding: EdgeInsets.only(right: 4.w, left: 6.w),
            child: SizedBox(
              height: 20.w,
              width: 20.w,
              child: Center(child: widget.suffixIcon),
            ),
          ),
          suffixIconConstraints:
          BoxConstraints(minHeight: 20.w, minWidth: 20.w),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
