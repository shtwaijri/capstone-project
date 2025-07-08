import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    super.key,
    required this.img,
    required this.bigText,
    required this.buttonText, this.onPressed,
  });
  final String img;
  final String bigText;
  final String buttonText;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StyleSize.sizeH48,
        SvgPicture.asset(img),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0,),
          child: Center(
            child: Text(
              bigText,
              style: StyleText.bold24(context), textAlign: TextAlign.center,
            ),
          ),
        ),
        StyleSize.sizeH8,
        Center(
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: StyleText.regular16Green(context).copyWith(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
