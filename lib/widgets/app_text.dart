import 'package:flutter/material.dart';
import '../utils/app_style.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final TextOverflow? textOverflow;
  final TextStyle? textStyle;
  final int? maxLines;

  const AppText({
    super.key,
    required this.text,
    this.align,
    this.textOverflow,
    this.textStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      overflow: textOverflow,
      style: textStyle ?? AppTextStyle.regularStyle,
      maxLines: maxLines,
    );
  }
}
