import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qaimati/style/style_color.dart';

void showDeleteItemAlertDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: StyleColor.white,
        contentPadding: EdgeInsets.all(30),
        content: Text(
          "Are you sure you want to delete this item?",
          style: TextStyle(color: StyleColor.red),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel", style: TextStyle(color: StyleColor.black)),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Delete", style: TextStyle(color: StyleColor.red)),
          ),
        ],
      );
    },
  );
}
