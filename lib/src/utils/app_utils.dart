import 'package:another_flushbar/flushbar.dart';
import 'package:commconnect/src/config/theme/app_colors.dart';
import 'package:commconnect/src/config/theme/app_styles.dart';
import 'package:commconnect/src/helpers/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  const AppUtils._();

  /// A utility method to convert 0/1 to false/true
  static bool boolFromInt(int i) => i == 1;

  /// A utility method to convert DateTime to API
  /// accepted date JSON format
  static String dateToJson(DateTime date) {
    return date.toDateString('yyyy-MM-dd');
  }

  /// A utility method to convert DateTime to API
  /// accepted datetime JSON format
  static String dateTimeToJson(DateTime date) {
    return date.toDateString('yyyy-MM-dd HH:mm:ss');
  }

  /// A utility method to convert JSON 24hr time string
  /// to a [TimeOfDay] object
  static TimeOfDay timeFromJson(String time) {
    final dateTime = DateFormat.Hms().parse(time);
    return TimeOfDay.fromDateTime(dateTime);
  }

  /// Helper method to show toast message
  static void showFlushBar({
    required BuildContext context,
    required String message,
    IconData? icon = Icons.error_rounded,
    double? iconSize = 28,
    Color? iconColor = Colors.redAccent,
    FlushbarPosition? postion = FlushbarPosition.BOTTOM,
  }) {
    Flushbar<void>(
      message: message,
      messageSize: 15,
      messageColor: AppColors.whiteColor,
      borderRadius: Corners.rounded8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      backgroundColor: const Color.fromARGB(218, 48, 48, 48),
      boxShadows: Shadows.universal,
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      shouldIconPulse: false,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: postion ?? FlushbarPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

/// A utility class that holds commonly used regular expressions
/// employed throughout the entire app.
/// This class has no constructor and all variables are `static`.
@immutable
class Regexes {
  const Regexes._();

  /// The regular expression for validating emails in the app.
  static RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\.]+\.(com|pk)+",
  );

  /// The regular expression for validating contacts in the app.
  // static RegExp contactRegex = RegExp(r'^(03|3)\d{9}$');
  static RegExp contactRegex = RegExp(r'^(?:\+91|0)?[6789]\d{9}$');

  /// The regular expression for validating names in the app.
  static RegExp nameRegex = RegExp(r'^[a-z A-Z]+$');

  /// The regular expression for validating zip codes in the app.
  // static RegExp zipCodeRegex = RegExp(r'^\d{6}$');
  static RegExp zipCodeRegex = RegExp(r'^(?!0{6})(\d{6})$');

  /// The regular expression for validating credit card expiry in the app.
  static final RegExp otpDigitRegex = RegExp(r'^[0-9]{1}$');
}

/// A utility class that holds all the timings used throughout
/// the entire app by things such as animations, tickers etc.
///
/// This class has no constructor and all variables are `static`.
@immutable
class Durations {
  const Durations._();

  static const fastest = Duration(milliseconds: 150);
  static const fast = Duration(milliseconds: 250);
  static const normal = Duration(milliseconds: 300);
  static const medium = Duration(milliseconds: 500);
  static const slow = Duration(milliseconds: 700);
  static const slower = Duration(milliseconds: 1000);
}
