import 'package:flutter/material.dart';

class CustomWidgetSetting extends StatelessWidget {
  CustomWidgetSetting({
    super.key,
    required this.icon,
    required this.text,
    required TextStyle style,
  });
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(children: [Icon(icon), Text(text)]);
  }
}
