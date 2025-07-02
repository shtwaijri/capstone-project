import 'package:flutter/material.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CustomWidgetSetting extends StatelessWidget {
  CustomWidgetSetting({
    super.key,
    required this.icon,
    required this.text,
    required this.style,
    required this.color,
    required this.iconSize,
    this.showSwitch = false,
    this.switchValue = false,
    this.onChanged,
  });

  final IconData icon;
  final String text;
  final TextStyle style;
  final Color? color;
  final double? iconSize;
  final bool? showSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.getWidth() * 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: iconSize),
              SizedBox(width: context.getWidth() * 0.02),
              Text(text, style: style),
            ],
          ),

          if (showSwitch!)
            Switch(
              value: switchValue ?? false,
              onChanged: onChanged ?? (value) {},
            ),
        ],
      ),
    );
  }
}
