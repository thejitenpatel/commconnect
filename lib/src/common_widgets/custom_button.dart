import 'package:commconnect/src/config/theme/app_colors.dart';
import 'package:commconnect/src/helpers/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double? width;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Gradient? gradient;
  final double borderRadius;
  final Widget child;

  const CustomButton({
    super.key,
    double? height,
    double? borderRadius,
    this.width,
    bool? disabled,
    this.gradient,
    this.border,
    this.color,
    this.padding,
    required this.child,
    required this.onPressed,
  })  : borderRadius = borderRadius ?? 8,
        height = height ?? 45,
        disabled = disabled ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textButtonTheme = theme.textButtonTheme;
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        color: color,
      ),
      clipBehavior: Clip.hardEdge,
      child: ElevatedButton(
        style: textButtonTheme.style!.copyWith(
          padding: MaterialStateProperty.all(padding),
          overlayColor: MaterialStateProperty.all(
            disabled ? AppColors.secondaryColor : AppColors.primaryColor,
          ),
        ),
        onPressed: disabled ? () {} : onPressed,
        child: child,
      ),
    );
  }
}
