import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:easy_localization/easy_localization.dart'; 

/// Displays an AlertDialog to confirm an item deletion.
///
/// This dialog provides "Cancel" and "Delete" options. If "Delete" is
/// confirmed, the `onDeleteConfirmed` callback function is executed.
///
/// [context] The BuildContext of the widget tree.
/// [onDeleteConfirmed] A callback function to be executed when the user confirms the deletion.


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