import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key, required this.onpressed});
  final Function? onpressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => onpressed!(),
        backgroundColor: Colors.green[200],
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.add),
      );
  }
}