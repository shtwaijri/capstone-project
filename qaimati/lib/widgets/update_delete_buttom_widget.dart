import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class UpdateDeleteButtomWidget extends StatelessWidget {
  /// A custom elevated button for udate and delete widget
  const UpdateDeleteButtomWidget({
    super.key,
    required this.onUpdate,
    required this.updateLablel,
    required this.onDelete,
    required this.deleteLabel,
  });

  /// Callback for update button press
  final Function()? onUpdate;

  /// Update button label
  final String updateLablel;

  /// Callback for onDelete button press
  final Function()? onDelete;

  /// Update button label
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            fixedSize: WidgetStateProperty.all(
              Size(context.getWidth() * .43, context.getHeight() * 0.06),
            ),
          ),
          onPressed: onUpdate,
          child: Center(
            child: Text(
              'Update the $updateLablel',
              style: StyleText.buttonText(context),
            ),
          ),
        ),
        StyleSize.sizeW16,
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: StyleColor.error,
            fixedSize: Size(
              context.getWidth() * .43,
              context.getHeight() * 0.06,
            ),
          ),
          onPressed: onDelete,
          child: Center(
            child: Text(
              'Delete the $deleteLabel',
              style: StyleText.buttonText(context),
            ),
          ),
        ),
      ],
    );
  }
}
