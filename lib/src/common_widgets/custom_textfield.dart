import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final double? width, height;
  final int? maxLength;
  final int? minLines;
  final String? floatingText, hintText;
  final TextStyle hintStyle, errorStyle, inputStyle;
  final TextStyle? floatingStyle;
  final EdgeInsets? contentPadding;
  final void Function(String? value)? onSaved, onChanged;
  final Widget? prefix, suffix;
  final bool showCursor;
  final bool? enabled;
  final bool multiline;
  final bool expands;
  final bool readOnly;
  final bool autofocus;
  final bool showErrorBorder;
  final bool showFocusedBorder;
  final BorderSide border;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final Alignment errorAlign, floatingAlign;
  final Color fillColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String? value)? validator;
  final String? labelText;

  const CustomTextField({
    super.key,
    this.controller,
    this.width,
    this.maxLength,
    this.minLines,
    this.floatingText,
    this.floatingStyle,
    this.onSaved,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.enabled,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.validator,
    this.height = 47,
    this.readOnly = false,
    this.showFocusedBorder = false,
    this.multiline = false,
    this.expands = false,
    this.showCursor = true,
    this.showErrorBorder = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.border = BorderSide.none,
    this.textAlignVertical = TextAlignVertical.center,
    this.errorAlign = Alignment.centerRight,
    this.floatingAlign = Alignment.centerLeft,
    this.fillColor = AppColors.whiteColor,
    this.hintStyle = const TextStyle(
      fontSize: 14,
      fontFamily: "Inter",
      color: AppColors.textLightGreyColor,
    ),
    this.errorStyle = const TextStyle(
      height: 0,
      // fontSize: 0,
      color: AppColors.redColor,
    ),
    this.inputStyle = const TextStyle(
      fontSize: 16,
      fontFamily: "Inter",
      color: AppColors.textLightGreyColor,
    ),
    this.contentPadding = const EdgeInsets.fromLTRB(12, 13, 0, 13),
    this.labelText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? errorText;
  bool hidePassword = true;

  bool get hasError => errorText != null;

  bool get showErrorBorder => widget.showErrorBorder && hasError;

  bool get hasFloatingText => widget.floatingText != null;

  bool get isPasswordField =>
      widget.keyboardType == TextInputType.visiblePassword;

  void _onSaved(String? value) {
    final trimmedValue = value!.trim();
    widget.controller?.text = trimmedValue;
    widget.onSaved?.call(trimmedValue);
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) {
      _runValidator(value);
      widget.onChanged!(value);
    }
  }

  String? _runValidator(String? value) {
    final error = widget.validator?.call(value!.trim());
    setState(() {
      errorText = error;
    });
    return error;
  }

  void _togglePasswordVisibility() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  OutlineInputBorder _focusedBorder() {
    return const OutlineInputBorder(
      borderRadius: Corners.rounded8,
      borderSide: BorderSide(
        color: AppColors.secondaryColor,
        width: 2,
      ),
    );
  }

  OutlineInputBorder _normalBorder() {
    return const OutlineInputBorder(
      borderRadius: Corners.rounded8,
      borderSide: BorderSide(
        color: AppColors.borderSideColor,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return const OutlineInputBorder(
      borderRadius: Corners.rounded8,
      borderSide: BorderSide(
        color: AppColors.redColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      expands: widget.expands,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.multiline ? null : 1,
      keyboardType: widget.keyboardType ??
          (widget.multiline ? TextInputType.multiline : null),
      textInputAction: widget.textInputAction ??
          (widget.multiline ? TextInputAction.newline : null),
      style: widget.inputStyle,
      showCursor: widget.showCursor,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      autovalidateMode: AutovalidateMode.disabled,
      cursorColor: AppColors.textLightGreyColor,
      obscureText: isPasswordField && hidePassword,
      validator: _runValidator,
      onFieldSubmitted: _runValidator,
      onSaved: _onSaved,
      onChanged: _onChanged,
      decoration: InputDecoration(
        label: Text(
          widget.labelText ?? "",
          style: const TextStyle(
            fontSize: 14,
            fontFamily: "Inter",
          ),
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        errorStyle: widget.errorStyle,
        errorText: errorText,
        fillColor: widget.fillColor,
        prefixIcon: widget.prefix,
        contentPadding: widget.contentPadding,
        isDense: true,
        filled: true,
        counterText: '',
        border: _normalBorder(),
        enabledBorder: _normalBorder(),
        focusedBorder: widget.showFocusedBorder ? _focusedBorder() : null,
        focusedErrorBorder: widget.showFocusedBorder ? _focusedBorder() : null,
        errorBorder: showErrorBorder ? _errorBorder() : null,
        suffixIcon: widget.suffix ??
            (isPasswordField
                ? InkWell(
                    onTap: _togglePasswordVisibility,
                    child: const Icon(
                      Icons.remove_red_eye_sharp,
                      // color: AppColors.textGreyColor,
                      size: IconSizes.med22,
                    ),
                  )
                : null),
      ),
    );
  }
}
