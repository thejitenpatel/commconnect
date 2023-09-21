import 'package:flutter/material.dart';

/// A utility class that holds all the icon sizes used throughout
/// the entire app.
///
/// This class has no constructor and all variables are `static`.
@immutable
class IconSizes {
  const IconSizes._();

  static const double sm18 = 18;
  static const double med22 = 22;
  static const double lg26 = 26;
}

@immutable
class Sizes {
  const Sizes._();
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;
  static const p48 = 48.0;
  static const p64 = 64.0;
}

/// A utility class that holds all the gaps and insets used
/// throughout the entire app by things such as padding, sizedbox etc.
///
/// This class has no constructor and all variables are `static`.
@immutable
class Insets {
  const Insets._();

  /// [SizedBox] of height **2**.
  static const gapH2 = SizedBox(height: 2);

  /// [SizedBox] of width **2**.
  static const gapW2 = SizedBox(width: 2);

  /// [SizedBox] of height **4**.
  static const gapH4 = SizedBox(height: 4);

  /// [SizedBox] of width **4**.
  static const gapW4 = SizedBox(width: 4);

  /// [SizedBox] of height **6**.
  static const gapH6 = SizedBox(height: 6);

  /// [SizedBox] of width **6**.
  static const gapW6 = SizedBox(width: 6);

  /// [SizedBox] of height **8**.
  static const gapH8 = SizedBox(height: 8);

  /// [SizedBox] of width **8**.
  static const gapW8 = SizedBox(width: 8);

  /// [SizedBox] of height **10**.
  static const gapH10 = SizedBox(height: 10);

  /// [SizedBox] of width **10**
  static const gapW10 = SizedBox(width: 10);

  /// [SizedBox] of width **12**
  static const gapW12 = SizedBox(width: 12);

  /// [SizedBox] of height **12**.
  static const gapH12 = SizedBox(height: 12);

  /// [SizedBox] of width **14**
  static const gapW14 = SizedBox(width: 14);

  /// [SizedBox] of height **14**.
  static const gapH14 = SizedBox(height: 14);

  /// [SizedBox] of height **16**.
  static const gapH16 = SizedBox(height: 16);

  /// [SizedBox] of height **16**.
  static const gapW16 = SizedBox(width: 16);

  /// [SizedBox] of height **20**.
  static const gapH20 = SizedBox(height: 20);

  /// [SizedBox] of height **20**.
  static const gapW20 = SizedBox(width: 20);

  /// [SizedBox] of height **25**.
  static const gapH25 = SizedBox(height: 25);

  /// [SizedBox] of height **25**.
  static const gapW25 = SizedBox(width: 25);

  /// [SizedBox] of height **30**.
  static const gapH30 = SizedBox(height: 30);

  /// [SizedBox] of height **30**.
  static const gapW30 = SizedBox(width: 30);

  /// [Spacer] for adding infinite gaps, as much as the constraints
  /// allow.
  static const expand = Spacer();

  /// The value for bottom padding of buttons in the app.
  /// It is measured from the bottom of the screen, that is
  /// behind the android system navigation.
  /// Used to prevent overlapping of android navigation with the button.
  static const bottomInsets = SizedBox(height: 38);

  /// The value for a smaller bottom padding of buttons in the app.
  /// It is measured from the bottom of the screen, that is
  /// behind the android system navigation.
  /// Used to prevent overlapping of android navigation with the button.
  static const bottomInsetsLow = SizedBox(height: 20);
}

/// A utility class that holds all the border radiuses used throughout
/// the entire app by things such as container, card etc.
///
/// This class has no constructor and all variables are `static`.
@immutable
class Corners {
  const Corners._();

  /// [BorderRadius] rounded on all corners by **4**
  static const BorderRadius rounded4 = BorderRadius.all(Radius.circular(4));

  /// [BorderRadius] rounded on all corners by **8**
  static const BorderRadius rounded8 = BorderRadius.all(Radius.circular(8));

  /// [BorderRadius] rounded on all corners by **10**
  static const BorderRadius rounded10 = BorderRadius.all(Radius.circular(10));

  /// [BorderRadius] rounded on all corners by **16**
  static const BorderRadius rounded16 = BorderRadius.all(Radius.circular(16));

  /// [BorderRadius] rounded on all corners by **20**
  static const BorderRadius rounded20 = BorderRadius.all(Radius.circular(20));

  /// [BorderRadius] rounded on all corners by **50**
  static const BorderRadius rounded50 = BorderRadius.all(Radius.circular(50));
}

/// A utility class that holds all the shadows used throughout
/// the entire app by things such as animations, tickers etc.
///
/// This class has no constructor and all variables are `static`.
@immutable
class Shadows {
  const Shadows._();

  static const List<BoxShadow> universal = [
    BoxShadow(
      color: Color.fromRGBO(51, 51, 51, 0.15),
      blurRadius: 10,
    ),
  ];

  static const elevated = <BoxShadow>[
    BoxShadow(
      color: Color.fromARGB(76, 158, 158, 158),
      blurRadius: 3,
      spreadRadius: -0.2,
      offset: Offset(2, 0),
    ),
    BoxShadow(
      color: Color.fromARGB(76, 158, 158, 158),
      blurRadius: 3,
      spreadRadius: -0.2,
      offset: Offset(-2, 0),
    ),
  ];

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color.fromRGBO(51, 51, 51, .15),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];
}
