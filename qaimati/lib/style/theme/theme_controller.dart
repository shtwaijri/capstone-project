import 'package:flutter/material.dart';

class ThemeController {
  static final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

  static void toggleTheme(bool isDark) {
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}
