import 'package:commconnect/src/config/theme/app_colors.dart';
import 'package:commconnect/src/helpers/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final double height;
  final double? width;
  final VoidCallback onPressed;
  final bool disabled;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final double borderRadius;
  final Widget child;

  const CustomTextButton({
    super.key,
    double? height,
    double? borderRadius,
    this.width,
    bool? disabled,
    this.border,
    this.color,
    this.padding,
    required this.child,
    required this.onPressed,
  })  : borderRadius = borderRadius ?? 7,
        height = height ?? 55,
        disabled = disabled ?? false;

  const factory CustomTextButton.outlined({
    Key? key,
    double? height,
    double? width,
    bool? disabled,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    required Border border,
    required Widget child,
    required VoidCallback onPressed,
  }) = _CustomTextButtonOutlined;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textButtonTheme = theme.textButtonTheme;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.borderSideColor,
        ),
        color: color,
      ),
      clipBehavior: Clip.hardEdge,
      child: TextButton(
        style: textButtonTheme.style!.copyWith(
          padding: MaterialStateProperty.all(padding),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: AppColors.whiteColor,
            ),
          ),
        ),
        onPressed: disabled ? () {} : onPressed,
        child: child,
      ),
    );
  }
}

class _CustomTextButtonOutlined extends CustomTextButton {
  const _CustomTextButtonOutlined({
    super.key,
    super.height,
    super.width,
    bool? disabled,
    super.borderRadius,
    super.padding,
    required Border super.border,
    required super.child,
    required super.onPressed,
  }) : super(
          disabled: disabled ?? false,
        );
}
