import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';

void alertDialog({
  required BuildContext context,
  required String lable,
  required Function() onTab,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: StyleColor.white,
      content: Text(
        // this will be as alert message befor delete any thing
        'Are you sure you want to delete this $lable?', // label is the thing that will be deleted [list - item - member .......]
        style: const TextStyle(color: StyleColor.error),
      ),
      actions: <Widget>[
        TextButton(
          // text button for cancel, just will pop the alert dialog
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: StyleColor.black)),
        ),
        TextButton(
          // text button for delete
          onPressed: onTab,
          child: Text('Delete', style: TextStyle(color: StyleColor.error)),
        ),
      ],
    ),
  );
}
