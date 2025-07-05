// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';


/// A custom widget designed to display a single item within a list,
/// such as an item in a shopping list
///
/// It features:
/// - A **checkbox** to mark the item as checked or unchecked.
/// - The **quantity** of the item.
/// - The **name/title** of the item.
/// - An optional **"important" indicator** (an icon) if the item is flagged as high priority.
/// - Information about **who created** the item.
///
/// The checkbox's current state (`isItemChecked`) and whether it's interactive (`isCheckboxEnabled`)
/// are controlled by properties passed into the widget. When enabled and toggled by the user,
/// it dispatches a `ToggleItemCheckedEvent` to the `SubListBloc` to update the item's status.


class CustomItems extends StatelessWidget {
  const CustomItems({
    super.key,
    required this.itemName,
    required this.numOfItems,
    required this.createdBy,
    required this.isImportant,
    required this.itemIndex,
    required this.isItemChecked,
    required this.itemId,
    this.isCheckboxEnabled = true,
    this.checkboxColor,
  });
  final String numOfItems;
  final String itemName;
  final String createdBy;
  final bool isImportant;
  final int itemIndex;
  final bool isItemChecked;
  final String itemId;
  final bool isCheckboxEnabled;
  final Color? checkboxColor;

  @override
  Widget build(BuildContext context) {
    final Color actualCheckboxColor = checkboxColor ?? StyleColor.green;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: context.getWidth() * 0.05,
            right: context.getWidth() * 0.04,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(
                  context.getWidth() * 0.015,
                  context.getHeight() * -0.008,
                ),
                child: Checkbox(
                  side: BorderSide(color: actualCheckboxColor),
                  value: isItemChecked,
                  onChanged: isCheckboxEnabled
                      ? (value) {
                          context.read<SubListBloc>().add(
                            ToggleItemCheckedEvent(
                              isChecked: value!,
                              itemId: itemId,
                            ),
                          );
                        }
                      : null,
                  fillColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.selected)) {
                      return actualCheckboxColor;
                    }

                    return actualCheckboxColor.withOpacity(0.5);
                  }),
                  checkColor: Colors.white,
                  overlayColor: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return actualCheckboxColor.withOpacity(0.1);
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return actualCheckboxColor.withOpacity(0.2);
                    }
                    return Colors.transparent;
                  }),
                ),
              ),
              SizedBox(width: context.getWidth() * 0.01),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$numOfItems - ',
                          style: StyleText.bold16(context),
                        ),
                        Flexible(
                          child: Text(
                            itemName,
                            style: StyleText.bold16(context),
                          ),
                        ),
                        if (isImportant)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.priority_high,
                              color: StyleColor.red,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'memberCreatedBy'.tr(),
                        style: StyleText.regular12(
                          context,
                        ).copyWith(fontSize: 10, color: StyleColor.gray),
                        children: [
                          TextSpan(
                            text: createdBy,
                            style: StyleText.bold12(
                              context,
                            ).copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        Divider(
          height: 0,
          color: StyleColor.gray,
          thickness: 1.01,
          indent: context.getWidth() * 0.04,
          endIndent: context.getWidth() * 0.17,
        ),
      ],
    );
  }
}
