import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    this.onDecrementMonth,
    this.onIncrementMonth,
    required this.formattedDate,
  });
  final String formattedDate;
  final Function()? onDecrementMonth;
  final Function()? onIncrementMonth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: context.getWidth(),
      height: context.getHeight() * 0.08,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_left,
              color: StyleColor.green,
              size: 32,
            ),
            onPressed: onDecrementMonth,
          ),

          Text(formattedDate, style: StyleText.bold16(context)),

          IconButton(
            icon: const Icon(
              Icons.arrow_right,
              color: StyleColor.green,
              size: 32,
            ),
            onPressed: onIncrementMonth,
          ),
        ],
      ),
    );
  }
}
