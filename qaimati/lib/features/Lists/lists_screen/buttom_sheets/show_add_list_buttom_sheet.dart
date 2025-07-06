import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/widgets/select_color.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/alert_dialog.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';
import 'package:qaimati/widgets/text_field_widget.dart';

void showAddListButtomSheet({
  required BuildContext context,
  required bool isEdit,
}) {
  TextEditingController addListController = TextEditingController();
  showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: StyleColor.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return BlocProvider(
        create: (context) => AddListBloc(),
        child: Builder(
          builder: (context) {
            final bloc = context.read<AddListBloc>();
            return Container(
              height: context.getHeight() * 0.6,
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // this is the  main column, every thing will be in it
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      // this sub clumn will be inside the main column, why i add it? to make spaseBetween buttom and oter widgets on top
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Add new list', style: StyleText.bold16(context)),
                        TextFieldWidget(
                          // may be i will use 2 text field ================================================= ================================================= no i dont
                          controller: addListController,
                          textHint: 'List name',
                        ),

                        BlocBuilder<AddListBloc, AddListState>(
                          builder: (context, state) {
                            return SelectColor(
                              selected: bloc.selectColor,
                              onTapSelect: bloc.changeColor,
                            );
                          },
                        ),
                      ],
                    ),
                    isEdit // if used in add list botton will apearing add list botton, and if used in edit list botton will apearing update and delete buttons
                        ? DualActionButtonWidget(
                            onPrimaryTap: () {},
                            primaryLabel: 'Save',
                            onSecondaryTap: () {
                              alertDialog(
                                context: context,
                                lable: 'list',
                                onTab: () {
                                  // bloc.add(DeleteListEvent(currentList.listId));
                                  // Navigator.pop(context);
                                },
                              );
                            },
                            secondaryLabel: 'Delete',
                            isDelete: true,
                            isCancel: false,
                          )
                        : ButtomWidget(
                            onTab: () {
                              final name = addListController.text
                                  .trim(); // trim to remove any leading or trailing spaces

                              if (name.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('List name is required'),
                                  ),
                                );
                                return;
                              }
                              context.read<AddListBloc>().add(
                                CreateListEvent(
                                  name: name,
                                  color: bloc.selectColor,
                                  createdAt: DateTime.now(),
                                ),
                              );
                              addListController.clear();
                              Navigator.pop(context);
                              context.read<AddListBloc>().add(
                                LoadListsEvent(),
                              ); // Reload lists manually
                            },
                            textElevatedButton: 'Create list',
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
