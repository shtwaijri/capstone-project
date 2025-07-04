import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime displayedDate = DateTime.now();

  void _decrementMonth() {
    setState(() {
      displayedDate = DateTime(displayedDate.year, displayedDate.month - 1);
    });
  }

  void _incrementMonth() {
    setState(() {
      displayedDate = DateTime(displayedDate.year, displayedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMMMM().format(displayedDate);

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
              color: StyleColor.black,
              size: 32,
            ),
            onPressed: _decrementMonth,
          ),

          Text(formattedDate, style: StyleText.bold16(context)),

          IconButton(
            icon: const Icon(
              Icons.arrow_right,
              color: StyleColor.black,
              size: 32,
            ),
            onPressed: _incrementMonth,
          ),
        ],
      ),
    );
  }
}
