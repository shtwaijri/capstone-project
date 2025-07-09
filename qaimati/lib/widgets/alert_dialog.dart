import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_text.dart';

void alertDialog({
  required BuildContext context,
  required String lable,
  required Function() onTab,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      // backgroundColor: StyleColor.white,
      content: Text(
        // this will be as alert message befor delete any thing
        lable, // label is the thing that will be deleted [list - item - member .......]
        style: StyleText.regular16Error(context),
      ),
      actions: <Widget>[
        TextButton(
          // text button for cancel, just will pop the alert dialog
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'commonCancel'.tr(),
            style: StyleText.regular16(context),
          ),
        ),
        TextButton(
          // text button for delete
          onPressed: onTab,
          child: Text(
            'commonDelete'.tr(),
            style: StyleText.regular16Error(context),
          ),
        ),
      ],
    ),
  );
}
