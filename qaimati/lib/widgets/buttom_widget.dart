import 'package:flutter/material.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class ButtomWidget extends StatelessWidget {
  /// A custom elevated button widget
  const ButtomWidget({
    super.key,
    required this.onTab,
    required this.textElevatedButton,
    Null Function()? onPressed,
  });

  /// Callback for button press
  final Function()? onTab;

  /// Button label
  final String textElevatedButton;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
          Size(context.getWidth() * .9, context.getHeight() * 0.06),
        ),
      ),
      onPressed: onTab,
      child: Center(
        child: Text(textElevatedButton, style: StyleText.buttonText16(context)),
      ),
    );
  }
}
