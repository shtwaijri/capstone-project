import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.onConfirm,
  });

  final TextEditingController controller;
  final String title;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(context.getWidth() * 0.02),

      title: Text(title, style: StyleText.bold16(context)),
      content: TextFormField(
        controller: controller,
        textAlign: TextAlign.start,

        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid),
          ),
        ),
      ),
      backgroundColor: StyleColor.graylight,

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            tr('commonCancel'),
            style: StyleText.bold16(context).copyWith(color: StyleColor.green),
          ),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            }
          },
          child: Text(
            tr('alertEdit'),
            style: StyleText.bold16(context).copyWith(color: StyleColor.green),
          ),
        ),
      ],
    );
  }
}
