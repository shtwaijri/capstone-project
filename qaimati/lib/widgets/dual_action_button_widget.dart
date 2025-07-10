import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

/// A row of two action buttons (primary + secondary).
/// Use it for actions like: Submit/Cancel, Update/Delete.
///
/// - Use [isCancel] to style the primary button as a cancel button.
/// - Use [isDelete] to style the secondary button as a delete button.
class DualActionButtonWidget extends StatelessWidget {
  const DualActionButtonWidget({
    super.key,
    required this.onPrimaryTap,
    required this.primaryLabel,
    required this.onSecondaryTap,
    required this.secondaryLabel,
    required this.isDelete,
    required this.isCancel,
  });

  final Function()? onPrimaryTap;
  final String primaryLabel;
  final Function()? onSecondaryTap;
  final String secondaryLabel;
  final bool isDelete;
  final bool isCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Primary button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCancel ? StyleColor.gray : StyleColor.green,
            fixedSize: Size(
              context.getWidth() * .40,
              context.getHeight() * 0.06,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPrimaryTap,
          child: Text(
            primaryLabel,
            style: StyleText.greenButtonText12(context),
          ),
        ),

        // Space between buttons
        StyleSize.sizeW16,

        // Secondary button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDelete ? StyleColor.error : StyleColor.green,
            fixedSize: Size(
              context.getWidth() * .42,
              context.getHeight() * 0.06,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onSecondaryTap,
          child: Text(secondaryLabel, style: StyleText.buttonText12(context)),
        ),
      ],
    );
  }
}
