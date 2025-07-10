// ignore_for_file: unnecessary_import

import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

/// A widget that displays the total spending amount for the month.
class SpendingWidget extends StatelessWidget {
  const SpendingWidget({super.key, required this.money});

  /// The total amount of money spent (as a double).
  final double money;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.getWidth(),
      height: context.getHeight() * 0.12,
      child: Card(
        color: StyleColor.blue,
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StyleSize.sizeW24,
            // Shows an icon
            Icon(Icons.wallet, size: 60, color: StyleColor.red),
            Container(color: StyleColor.gray, width: 2, height: 80),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              //The spending amount with a Riyal icon.
              children: [
                Text(
                  'receiptMonthly'.tr(),
                  style: StyleText.bold16black(context),
                ),
                Row(
                  textDirection: ui.TextDirection.ltr,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/Riyal.svg',
                      width: 16,
                      height: 16,
                    ),
                    StyleSize.sizeW8,
                    Text('$money', style: StyleText.bold16black(context)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
