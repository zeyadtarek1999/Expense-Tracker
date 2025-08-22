import 'package:flutter/material.dart';

import '../custom_text.dart';

class CustomOutlineButtonWidget extends StatelessWidget {
  const CustomOutlineButtonWidget(
      {super.key,
      required this.btnWidth,
      required this.btnHeight,
      required this.text,
      required this.onPressed,
      this.style,
      this.textStyle});

  final double btnWidth;
  final double btnHeight;
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: btnHeight,
      width: btnWidth,
      child: OutlinedButton(
        onPressed: onPressed,
        style: style ?? Theme.of(context).outlinedButtonTheme.style,
        child: CustomTextWidget(
          text: text,
          textStyle: textStyle ??
              Theme.of(context)
                  .outlinedButtonTheme
                  .style!
                  .textStyle!
                  .resolve({}),
        ),
      ),
    );
  }
}
