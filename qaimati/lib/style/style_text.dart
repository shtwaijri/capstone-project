
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';

class StyleText {
  static String _getFontFamily(context) {
    return
    // context.locale.languageCode == 'en'
    'SFCompactRounded';
    // : 'SFArabicRounded';
  }

  static Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? StyleColor.white
        : StyleColor.black;
  }

  static TextStyle bold24(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }

  static TextStyle bold16(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }

  static TextStyle bold12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _getTextColor(context),
    );
  }

  static TextStyle regular16(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _getTextColor(context),
    );
  }

  static TextStyle regular12(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: _getTextColor(context),
    );
  }

  static TextStyle buttonText(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: StyleColor.white,
    );
  }

  static TextStyle regular16Green(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: StyleColor.green,
    );
  }

  static TextStyle regular16Error(BuildContext context) {
    return TextStyle(
      fontFamily: _getFontFamily(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: StyleColor.red,
    );
  }
}
