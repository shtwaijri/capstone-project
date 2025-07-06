import 'package:flutter/material.dart';
import 'package:qaimati/style/style_text.dart';

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
    final double width = MediaQuery.of(context).size.width * 0.13;
    final double height = MediaQuery.of(context).size.height * 0.08;
    final EdgeInsets padding = EdgeInsets.symmetric(
      vertical: MediaQuery.of(context).size.height * 0.01,
      horizontal: MediaQuery.of(context).size.width * 0.02,
    );

    final TextStyle style = StyleText.bold16(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          padding: padding,
          child: TextFormField(
            style: style,
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
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
      ],
    );
  }
}
