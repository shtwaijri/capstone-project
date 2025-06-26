import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/button/item_quantity_selector.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/buttom_widget.dart';

void showAddItemBottomShaeet({
  required BuildContext context,
  required int number,
}) {
  final bloc = context.read<SubListBloc>();

  showModalBottomSheet(
    isScrollControlled: true,

    backgroundColor: StyleColor.white,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: Padding(
           padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // هذا يجعل الـ BottomSheet يرفع مع الكيبورد
      ),
          child: SingleChildScrollView(
            child: Container(
              width: context.getWidth(),
              height: context.getHeight() * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to start (left)
                children: [
                  StyleSize.sizeH32,
                  Text(
                    "Item", // Add the "Item" text as seen in the image
                    style: StyleText.bold24(context),
                  ),
                  StyleSize.sizeH16,
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: ItemQuantitySelector(number: number),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextField(
                          controller: bloc.itemController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 8,
                            ),
                            hintText: "itemName".tr(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                4.0,
                              ), // Rounded corners for text field
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add a SizedBox here if you need space between the row and the icon
                  StyleSize.sizeH16,
            
                  BlocBuilder<SubListBloc, SubListState>(
                    // Listen only to ChooseImportanceState to rebuild just the icon
                    buildWhen: (previous, current) =>
                        current is ChooseImportanceState,
                    builder: (context, state) {
                      bool isExclamationImportant = bloc.isItemImportant;
            
                      return Container(
                        // Use Align to position the icon
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // Toggle the importance state and dispatch the event
                            context.read<SubListBloc>().add(
                              ChooseImportanceEvent(
                                isImportant: !isExclamationImportant,
                              ),
                            );
                          },
                          icon: Icon(
                            !isExclamationImportant
                                ? CupertinoIcons.exclamationmark_square
                                : CupertinoIcons.exclamationmark_square_fill,
                            // Change color based on the state from the BLoC
                            color: StyleColor
                                .red, // Or any default color when not important
                            size: context.getWidth() * .09, // Adjust size as needed
                          ),
                        ),
                      );
                    },
                  ),
            
                  Spacer(), // Pushes the button to the bottom
                  ButtomWidget(onTab: () {}, textElevatedButton: "itemAdd".tr()),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
