import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('receipt'.tr(), style: StyleText.bold24(context)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: StyleColor.graylight, height: 1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: context.getWidth(),
          height: context.getHeight() * 0.5,
          child: DottedBorder(
            options: RectDottedBorderOptions(
              borderPadding: EdgeInsets.all(16),
              color: StyleColor.black,
              dashPattern: [6, 4],
              strokeWidth: 2,
              padding: EdgeInsets.all(16),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Cover Photo", style: StyleText.bold16(context)),
                  Text(
                    "(up to 12 Mb)",
                    style: StyleText.regular12Grey(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
