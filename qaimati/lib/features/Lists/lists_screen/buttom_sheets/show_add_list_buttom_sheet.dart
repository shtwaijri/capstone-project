import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/widgets/select_color.dart';
import 'package:qaimati/models/list/list_model.dart';
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
  String? listId, // ✅ جديد
  ListModel? list,
}) {
  TextEditingController addListController = TextEditingController(
    text: isEdit ? list?.name ?? '' : '',
  );

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('listNew'.tr(), style: StyleText.bold16(context)),
                      TextFieldWidget(
                        controller: addListController,
                        textHint: 'listName'.tr(),
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
                  isEdit
                      ? DualActionButtonWidget(
                          onPrimaryTap: () {
                            if (list == null) {
                              print("❌ list is null, can't update.");
                              return;
                            }

                            final name = addListController.text.trim();
                            if (name.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('List name is required'),
                                ),
                              );
                              return;
                            }

                            final bloc = context.read<AddListBloc>();
                            bloc.add(
                              UpdateListEvent(
                                ListModel(
                                  listId: list.listId,
                                  name: name,
                                  color: bloc.selectColor,
                                  createdAt: list.createdAt,
                                ),
                              ),
                            );

                            addListController.clear();
                            Navigator.pop(context);
                            context.read<AddListBloc>().add(LoadListsEvent());
                          },

                          primaryLabel: 'listUpdate'.tr(),
                          onSecondaryTap: () {
                            alertDialog(
                              context: context,
                              lable: 'listDeleteConfirm'.tr(),
                              onTab: () {
                                if (listId != null) {
                                  print(
                                    '🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥 listId to delete: $listId 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥',
                                  );
                                  context.read<AddListBloc>().add(
                                    DeleteListEvent(listId),
                                  );
                                }
                                Navigator.pop(context);
                                Navigator.pop(context);
                                context.read<AddListBloc>().add(
                                  LoadListsEvent(),
                                );
                              },
                            );
                          },
                          secondaryLabel: 'listDelete'.tr(),
                          isDelete: true,
                          isCancel: false,
                        )
                      : ButtomWidget(
                          onTab: () {
                            final name = addListController.text.trim();

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
                            context.read<AddListBloc>().add(LoadListsEvent());
                          },
                          textElevatedButton: 'listNew'.tr(),
                        ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
