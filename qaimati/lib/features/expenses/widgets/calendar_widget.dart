import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

/// A widget that displays a calendar header with left and right arrows
/// to navigate between months, and shows the currently selected month.
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    this.onDecrementMonth,
    this.onIncrementMonth,
    required this.formattedDate,
  });

  /// The formatted string of the current month and year
  final String formattedDate;

  /// Callback triggered when the left arrow is pressed
  final Function()? onDecrementMonth;

  /// Callback triggered when the right arrow is pressed
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
          // Left arrow to go to the previous month
          IconButton(
            icon: const Icon(
              Icons.arrow_left,
              color: StyleColor.green,
              size: 32,
            ),
            onPressed: onDecrementMonth,
          ),
          // Displays the current formatted date
          Text(formattedDate, style: StyleText.bold16(context)),
          // Right arrow to go to the next month
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
