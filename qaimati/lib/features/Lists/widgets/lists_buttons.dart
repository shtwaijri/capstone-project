import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
// import 'package:test_befor_add/style/style_color.dart';
// import 'package:test_befor_add/style/style_text.dart';//

class ListsButtons extends StatelessWidget {
  const ListsButtons({
    super.key,
    required this.icon,
    required this.quantity,
    required this.lable, required this.screen,
  });
  final Icon icon;
  final String quantity;
  final String lable;
  final Widget screen;
  final Color cocntentColor = StyleColor.black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        width: 170,
        height: 80,
        decoration: BoxDecoration(
          color: StyleColor.graylight,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: StyleColor.black.withValues(alpha: 0.3),
              spreadRadius: 0.2,
              blurRadius: 3,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon,
                  // Text(quantity, style: StyleText.bold16black(context)),
                  Text(lable, style: StyleText.bold16black(context))
                ],
              ),
              Row(children: []),
            ],
          ),
        ),
      ),
    );
  }
}