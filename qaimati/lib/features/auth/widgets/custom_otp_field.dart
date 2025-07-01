import 'package:flutter/material.dart';

class CustomOtpField extends StatelessWidget {
  const CustomOtpField({
    super.key,
    required this.focusNode,
    required this.nextFocus,
    required this.changed,
  });

  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final void Function(String)? changed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 48,
          width: 52,

          child: TextFormField(
            autofocus: true,
            focusNode: focusNode,
            onSaved: (pin1) {},
            keyboardType: TextInputType.number,
            maxLength: 1,

            onChanged: (value) {
              if (value.isNotEmpty && nextFocus != null) {
                FocusScope.of(context).requestFocus(nextFocus);
              }
              if (changed != null) changed!(value);
            },

            decoration: InputDecoration(
              border: OutlineInputBorder(),
              counterText: "",
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
