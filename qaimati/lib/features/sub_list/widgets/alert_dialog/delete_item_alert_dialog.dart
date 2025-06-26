import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:easy_localization/easy_localization.dart'; 

void showDeleteItemAlertDialog({
  required BuildContext context,
  required Function() onDeleteConfirmed,  
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: StyleColor.white,
        contentPadding: EdgeInsets.all(30),
        content: Text(
          "deleteItemConfirmation".tr(),  
          style: TextStyle(color: StyleColor.red),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);  
            },
            child: Text( "commonCancel".tr(), style: TextStyle(color: StyleColor.black)), 
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);  
              onDeleteConfirmed();  
            },
            child: Text( "commonDelete".tr(), style: TextStyle(color: StyleColor.red)), 
          ),
        ],
      );
    },
  );
}