import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/custom_items_widget/bloc/check_box_bloc.dart';

class CustomItems extends StatelessWidget {
  const CustomItems({
    super.key,
    required this.itemName,
    required this.numOfItems,
    required this.createdBy,
    required this.isImportant,
  });
  final String numOfItems;
  final String itemName;
  final String createdBy;
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckBoxBloc(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: context.getWidth() * 0.05),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(
                    context.getWidth() * 0.015,
                    context.getHeight() * -0.008,
                  ),
                  child: BlocBuilder<CheckBoxBloc, CheckBoxState>(
                    builder: (context, state) {
                      bool isChecked;
                      if (state is CheckboxValueState) {
                        isChecked = state.isChecked;
                      } else {
                        isChecked = false;
                      }
                      return Checkbox(
                        side: BorderSide(color: StyleColor.green),
                        value: isChecked,
                        onChanged: (value) {
                          context.read<CheckBoxBloc>().add(
                            PressCheckBoxEvent(value!),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: context.getWidth() * 0.01),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$numOfItems - ',
                          style: StyleText.bold16(context),
                        ),
                        Text(itemName, style: StyleText.bold16(context)),
                      ],
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'memberCreatedBy '.tr(),
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
                if (isImportant)
                  Padding(
                    padding: EdgeInsets.only(left: context.getWidth() * 0.25),
                    child: Icon(Icons.priority_high, color: StyleColor.red),
                  ),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: StyleColor.gray,
            thickness: 1.01,
            indent: context.getWidth() * 0.04,
            endIndent: context.getWidth() * 0.17,
          ),
        ],
      ),
    );
  }
}
