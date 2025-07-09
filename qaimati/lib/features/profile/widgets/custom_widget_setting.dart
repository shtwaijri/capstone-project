import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CustomWidgetSetting extends StatelessWidget {
  CustomWidgetSetting({
    super.key,
    required this.icon,
    required this.text,
    // required this.style,
    required this.color,
    required this.iconSize,
    this.showSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.onTap,
  });

  final IconData icon;
  final String text;
  // final TextStyle style;
  final Color? color;
  final double? iconSize;
  final bool? showSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Icon(icon, color: color, size: iconSize),
        SizedBox(width: context.getWidth() * 0.02),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold), )//style: style),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.getWidth() * 0.07),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          onTap != null
              ? GestureDetector(onTap: onTap, child: content)
              : content,
          if (showSwitch!)
            Theme(
              data: Theme.of(context).copyWith(
                switchTheme: SwitchThemeData(
                  trackOutlineColor: WidgetStateProperty.all(
                    Colors.transparent,
                  ),
                ),
              ),
              child: Switch(
                value: switchValue ?? false,
                onChanged: onChanged ?? (value) {},
                activeColor: StyleColor.white,
                activeTrackColor: StyleColor.green,
                inactiveThumbColor: StyleColor.white,
                inactiveTrackColor: Color.fromARGB(255, 228, 228, 231),
              ),
            ),
        ],
      ),
    );
  }
}
