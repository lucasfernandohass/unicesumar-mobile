import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Dark Mode Colors
const screenBackgroundDark = Color(0xFF111111);
const searchBarBackgroundDark = Color(0xFF1E1E1E);
const primaryButtonDark = Color(0xFFD9D9D9);
const posterBorderDark = Color(0xFFB5A9A9);
const buttonGreyDark = Color(0xFF504F4F);

// Light Mode Colors
const screenBackgroundLight = Color(0xFFFAFAFA);
const searchBarBackgroundLight = Color(0xFFF0F0F0);
const primaryButtonLight = Color(0xFF333333);
const posterBorderLight = Color(0xFF999999);
const buttonGreyLight = Color(0xFFCCCCCC);

// Default (dark mode)
const screenBackground = screenBackgroundDark;
const searchBarBackground = searchBarBackgroundDark;
const primaryButton = primaryButtonDark;
const posterBorder = posterBorderDark;
const buttonGrey = buttonGreyDark;

Color screenBackgroundColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? screenBackgroundDark : screenBackgroundLight;
Color searchBarBackgroundColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? searchBarBackgroundDark : searchBarBackgroundLight;
Color primaryButtonColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? primaryButtonDark : primaryButtonLight;
Color posterBorderColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? posterBorderDark : posterBorderLight;
Color buttonGreyColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? buttonGreyDark : buttonGreyLight;

var roboto = GoogleFonts.roboto();

var largeTitle = roboto.copyWith(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);
var heading1 = roboto.copyWith(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);
var heading2 = roboto.copyWith(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);
var body1Regular = roboto.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
var body1Bold = roboto.copyWith(
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
var body2Regular = roboto.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
var body2Bold = roboto.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
var caption = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
var body3Regular = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);
var body3Bold = roboto.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);
var verySmallText = roboto.copyWith(
  fontSize: 10,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

ThemeData createTheme({bool isDarkMode = true}) {
  if (isDarkMode) {
    return _createDarkTheme();
  } else {
    return _createLightTheme();
  }
}

ThemeData _createDarkTheme() {
  var darkLargeTitle = roboto.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  var darkHeading1 = roboto.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  var darkHeading2 = roboto.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  var darkBody1Regular = roboto.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  var darkBody1Bold = roboto.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  var darkBody2Regular = roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  var darkBody2Bold = roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
  var darkCaption = roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  var darkBody3Regular = roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: screenBackgroundDark,
    textTheme: Typography.material2021().englishLike.copyWith(
          headlineLarge: darkHeading1,
          headlineMedium: darkHeading2,
          headlineSmall: darkBody2Regular,
          titleLarge: darkLargeTitle,
          titleMedium: darkHeading2,
          titleSmall: darkBody2Bold,
          bodyLarge: darkBody1Regular,
          bodyMedium: darkBody2Regular,
          bodySmall: darkBody3Regular,
          labelLarge: darkBody1Bold,
          labelMedium: darkBody2Bold,
          labelSmall: darkCaption,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: screenBackgroundDark,
      foregroundColor: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: searchBarBackgroundDark,
        labelTextStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Colors.white);
          }
          return const TextStyle(color: posterBorderDark);
        }),
        iconTheme: WidgetStateProperty.all<IconThemeData>(
            const IconThemeData(color: Colors.white)),
        indicatorColor: posterBorderDark),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: searchBarBackgroundDark,
      selectedItemColor: Colors.white,
      unselectedLabelStyle: TextStyle(color: Colors.white),
      showUnselectedLabels: true,
      unselectedItemColor: posterBorderDark,
    ),
  );
}

ThemeData _createLightTheme() {
  var lightLargeTitle = roboto.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  var lightHeading1 = roboto.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  var lightHeading2 = roboto.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  var lightBody1Regular = roboto.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  var lightBody1Bold = roboto.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  var lightBody2Regular = roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  var lightBody2Bold = roboto.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );
  var lightCaption = roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  var lightBody3Regular = roboto.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: screenBackgroundLight,
    textTheme: Typography.material2021().englishLike.copyWith(
          headlineLarge: lightHeading1,
          headlineMedium: lightHeading2,
          headlineSmall: lightBody2Regular,
          titleLarge: lightLargeTitle,
          titleMedium: lightHeading2,
          titleSmall: lightBody2Bold,
          bodyLarge: lightBody1Regular,
          bodyMedium: lightBody2Regular,
          bodySmall: lightBody3Regular,
          labelLarge: lightBody1Bold,
          labelMedium: lightBody2Bold,
          labelSmall: lightCaption,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: screenBackgroundLight,
      foregroundColor: Colors.black,
    ),
    navigationBarTheme: NavigationBarThemeData(
        backgroundColor: searchBarBackgroundLight,
        labelTextStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Colors.black);
          }
          return const TextStyle(color: posterBorderLight);
        }),
        iconTheme: WidgetStateProperty.all<IconThemeData>(
            const IconThemeData(color: Colors.black)),
        indicatorColor: posterBorderLight),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: searchBarBackgroundLight,
      selectedItemColor: Colors.black,
      unselectedLabelStyle: TextStyle(color: Colors.black),
      showUnselectedLabels: true,
      unselectedItemColor: posterBorderLight,
    ),
  );
}

