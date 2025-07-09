import 'package:flutter/material.dart';

class AuthTextFieldWidget extends StatelessWidget {
  /// A reusable text field widget with label, hint, and validation.
  const AuthTextFieldWidget({
    super.key,

    this.validate,
    required this.controller,
    required this.textHint,
    required this.isPassword,
  });

  /// Controller to manage the text input
  final TextEditingController controller;

  /// Hint text shown inside the text field
  final String textHint;

  /// validator function for input validation
  final String? Function(String?)? validate;

  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      //to show the validation conditions while user's interaction
      autovalidateMode: AutovalidateMode.onUserInteraction,

      decoration: InputDecoration(
        hintText: textHint,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validate,
    );
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';

    final regExp = RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$');
    if (!regExp.hasMatch(email)) return 'Email is not correct';

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    if (password.length <= 8) {
      return 'Password must have more than 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Uppercase letter is missing.';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Lowercase letter is missing.';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Digit is missing.';

    return null;
  }
}
