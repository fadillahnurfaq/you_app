import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'widgets.dart';

enum ButtonStyleType { filled, outlined }

class AppButton extends StatelessWidget {
  const AppButton.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 16.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 18.0,
    this.textStyle,
    this.sideColor,
  });

  const AppButton.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 16.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 18.0,
    this.textStyle,
    this.sideColor,
  });

  final Function() onPressed;
  final String label;
  final ButtonStyleType style;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;
  final TextStyle? textStyle;
  final Color? sideColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      // decoration: BoxDecoration(
      //   gradient: AppColors.buttonGradient,
      //   borderRadius: BorderRadius.circular(borderRadius),
      // ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: disabled ? 0.5 : 1.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: style == ButtonStyleType.filled
                ? ElevatedButton(
                    onPressed: disabled ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      overlayColor: AppColors.white.withValues(alpha: 0.5),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon ?? const SizedBox.shrink(),
                        if (icon != null && label.isNotEmpty)
                          const SizedBox(width: 10.0),
                        AppText(
                          text: label,
                          textStyle:
                              textStyle ??
                              AppTextStyle.h4.copyWith(color: AppColors.white),
                        ),
                        if (suffixIcon != null && label.isNotEmpty)
                          const SizedBox(width: 10.0),
                        suffixIcon ?? const SizedBox.shrink(),
                      ],
                    ),
                  )
                : OutlinedButton(
                    onPressed: disabled ? null : onPressed,
                    style: OutlinedButton.styleFrom(
                      overlayColor: AppColors.white.withValues(alpha: 0.5),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: sideColor ?? Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon ?? const SizedBox.shrink(),
                        if (icon != null && label.isNotEmpty)
                          const SizedBox(width: 10.0),
                        AppText(
                          text: label,
                          textStyle:
                              textStyle ??
                              AppTextStyle.h4.copyWith(color: AppColors.white),
                        ),

                        if (suffixIcon != null && label.isNotEmpty)
                          const SizedBox(width: 10.0),
                        suffixIcon ?? const SizedBox.shrink(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
