// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: StyleColor.green,
      onPrimary: StyleColor.black,
      secondary: StyleColor.blue,
      onSecondary: StyleColor.black,
      error: StyleColor.red,
      onError: StyleColor.red,
      surface: StyleColor.green,
      onSurface: StyleColor.black,
    ),
    scaffoldBackgroundColor: StyleColor.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        backgroundColor: WidgetStateProperty.all(StyleColor.green),
        foregroundColor: WidgetStateProperty.all(StyleColor.white),
        overlayColor: WidgetStatePropertyAll(StyleColor.gray),
      ),
    ),
    listTileTheme: ListTileThemeData(tileColor: Colors.transparent),
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: StyleColor.white,
      selectedItemColor: StyleColor.green,
      unselectedItemColor: StyleColor.green.withOpacity(0.6),
    ),
    cardColor: StyleColor.gray,
    dividerColor: StyleColor.gray,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: StyleColor.green,
      onPrimary: StyleColor.white,
      secondary: StyleColor.blue,
      onSecondary: StyleColor.white,
      error: StyleColor.red,
      onError: StyleColor.red,
      surface: StyleColor.green,
      onSurface: StyleColor.white,
    ),
    scaffoldBackgroundColor: StyleColor.black,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.center,
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        backgroundColor: WidgetStateProperty.all(StyleColor.green),
        foregroundColor: WidgetStateProperty.all(StyleColor.white),
        overlayColor: WidgetStatePropertyAll(StyleColor.gray),
      ),
    ),
    listTileTheme: ListTileThemeData(tileColor: Colors.transparent),
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: StyleColor.black,
      selectedItemColor: StyleColor.green,
      unselectedItemColor: StyleColor.gray,
    ),
    cardColor: StyleColor.gray,
    dividerColor: StyleColor.gray,
  );
}
