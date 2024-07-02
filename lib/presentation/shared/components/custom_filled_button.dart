import 'package:flutter/material.dart';

import '../../theme/config/app_color.dart';
import 'app_text_theme.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    super.key,
    required this.title,
    this.onTap,
    this.borderRadius,
    this.radius,
    this.size,
    this.color,
    this.textColor,
    this.isLoading,
  });

  factory CustomFilledButton.secondary({
    double? radius,
    required String title,
    required VoidCallback? onTap,
    BorderRadius? borderRadius,
    final Size? size,
  }) =>
      CustomFilledButton(
        title: title,
        size: size,
        radius: radius,
        borderRadius: borderRadius,
        onTap: onTap,
        textColor: AppColor.primary,
        color: AppColor.primary,
      );

  final String title;
  final double? radius;
  final VoidCallback? onTap;
  final Size? size;
  final Color? color;
  final Color? textColor;
  final BorderRadiusGeometry? borderRadius;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ElevatedButton(
        onPressed: (isLoading == true) ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColor.primary,
          shadowColor: color,
          foregroundColor: color,
          surfaceTintColor: color,
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.all(Radius.circular(radius ?? 10)),
          ),
          elevation: 0,
          fixedSize: size ?? const Size.fromHeight(50),
        ),
        child: isLoading == true
            ? const CircularProgressIndicator(
                color: AppColor.white,
              )
            : Text(
                title,
                style: AppTextTheme.semiBold16.copyWith(
                  color: textColor ?? Colors.white,
                  letterSpacing: 0.5,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}
