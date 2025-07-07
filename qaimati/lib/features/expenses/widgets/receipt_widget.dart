import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

/// A widget that displays a receipt summary with the store name and total amount.
///
/// It shows the store name on the left and the total amount on the right
/// with a Riyal currency icon.
class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({
    super.key,
    required this.storName,
    required this.total,
    required this.currency,
  });

  /// The name of the store or supplier.
  final String storName;

  /// The total amount as a string to display.
  final String total;

  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.getWidth(),
      height: context.getHeight() * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: StyleColor.graylight,
      ),

      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Store name text
            Text(storName, style: StyleText.bold16(context)),
            // Row showing currency icon and total amount
            Row(
              children: [
                SvgPicture.asset('assets/svg/Riyal.svg', width: 16, height: 16),
                StyleSize.sizeW8,
                Text(total, style: StyleText.bold16(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
