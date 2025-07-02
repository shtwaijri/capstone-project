import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
// import 'package:test_befor_add/style/style_color.dart';

class ColorsWidget extends StatelessWidget {
  const ColorsWidget({super.key, required this.color, this.isSelected});
  final Color color;
  final bool? isSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected! ? StyleColor.black : Colors.transparent,
            width: isSelected! ? 2.0 : 0.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}