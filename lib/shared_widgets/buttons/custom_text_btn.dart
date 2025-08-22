import 'package:flutter/material.dart';
import '../custom_text.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double btnWidth;
  final double btnHeight;
  final ButtonStyle? style;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const CustomTextButtonWidget({
    super.key,
    required this.text,
    required this.btnWidth,
    required this.btnHeight,
    this.style,
    this.textStyle,
    required this.onPressed,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: btnWidth,
      height: btnHeight,
      child: TextButton(
        onPressed: onPressed,
        style: style ?? Theme.of(context).textButtonTheme.style,
        child: CustomTextWidget(
          text: text,
          textStyle: textStyle ??
              Theme.of(context).textButtonTheme.style!.textStyle!.resolve({}),
        ),
      ),
    );
  }
}
