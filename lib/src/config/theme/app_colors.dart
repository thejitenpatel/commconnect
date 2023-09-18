import 'package:flutter/material.dart';

/// A utility class that holds constants for colors used values
/// throughout the entire app.
/// This class has no constructor and all variables are `static`.
@immutable
class AppColors {
  const AppColors._();

  /// The main purplish color used for theming the app.
  static const Color primaryColor = Color(0xFF6366F1);

  /// The secondary light purple color used for contrasting
  /// the primary purple in the app
  static const Color secondaryColor = Color(0xFFA5B4FC);

  /// The tertiary blackish color used for contrasting
  static const Color tertiaryColor = Color(0xFF101027);

  /// The white color used for background
  static const Color whiteColor = Colors.white;

  /// The white color used for background
  static const Color greyColor = Colors.grey;

  /// The darker greyish color used for background surfaces
  /// of the app like behind scrolling screens or scaffolds etc.
  static const Color backgroundColor = Color(0xFFF5F5F5);

  /// The color value for red color in the app.
  static const Color redColor = Color(0xFFed0000);

  /// The color value for light grey text in the app.
  static const Color textLightGreyColor = Color(0xFF1A1A1A);

  /// The color value for dark grey text in the app.
  static const Color textBlackColor = Color(0xFF101027);

  /// The color value for white text in the app.
  static const Color textWhiteColor = Color(0xFFFFFFFF);

  /// The light greyish color used for filling fields of the app.
  static const Color fieldFillColor = Color(0xFFA5B4FC);

  /// The color value for dark grey [CustomDialog] in the app.
  static const Color barrierColor = Colors.black87;

  /// The color value for light grey for Text Field bored in the app.
  static const Color borderSideColor = Colors.black12;

  /// The color value for Green for success value in the app.
  static const Color successColor = Colors.green;
}
