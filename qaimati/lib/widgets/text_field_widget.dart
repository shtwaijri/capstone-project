import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';

class TextFieldWidget extends StatelessWidget {
  /// A reusable text field widget with hint and validation.
  const TextFieldWidget({
    super.key,
    this.validate,
    required this.controller,
    required this.textHint,
    this.keyboardType,
  });

  /// Controller to manage the text input
  final TextEditingController controller;

  /// Hint text shown inside the text field
  final String textHint;

  /// validator function for input validation
  final String? Function(String?)? validate;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.text,
      // style: TextStyle(color: StyleColor.black),
      controller: controller,
      decoration: InputDecoration(
        hintText: textHint,
        hintStyle: StyleText.regular16Grey(context),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: StyleColor.gray),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: StyleColor.gray),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: StyleColor.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: StyleColor.red),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: validate,
    );
  }
}
