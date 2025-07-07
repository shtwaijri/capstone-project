import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CustomShimmerEffect extends StatelessWidget {
  const CustomShimmerEffect({super.key, required this.isItem});
  final bool isItem;
  static const double itemRadius = 2;
  static const double otherRadius = 10;

  static const double itemHieght = 0.08;
  static const double otherHieght = 0.065;

  static const int itemNum=7;
  static const int otherNum=5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(isItem ? itemNum : otherNum, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: FadeShimmer(
              millisecondsDelay: 50,
              height: context.getHeight() * (isItem ? itemHieght : otherHieght),
              width: context.getWidth() * 0.8,
              radius: isItem ? itemRadius : otherRadius, //10,
              baseColor: StyleColor.gray,
              highlightColor: StyleColor.graylight,
            ),
          );
        }),
      ),
    );
  }
}
