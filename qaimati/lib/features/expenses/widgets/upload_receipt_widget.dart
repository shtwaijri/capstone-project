import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

/// A widget that shows a dotted border container
/// prompting the user to upload a receipt photo.
///
/// Inside, it displays localized text instructions.
class UploadReceiptWidget extends StatelessWidget {
  const UploadReceiptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.getWidth(),
      height: context.getHeight() * 0.4,
      child: DottedBorder(
        // Customize the dotted border style
        options: RectDottedBorderOptions(
          color: StyleColor.gray,
          dashPattern: [6, 4],
          strokeWidth: 2,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Texts
              Text('receiptPhoto'.tr(), style: StyleText.bold16(context)),
              Text(
                'receiptSizeNote'.tr(),
                style: StyleText.regular12Grey(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
