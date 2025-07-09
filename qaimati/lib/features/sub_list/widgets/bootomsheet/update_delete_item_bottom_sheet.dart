import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/alert_dialog/delete_item_alert_dialog.dart';
import 'package:qaimati/features/sub_list/widgets/button/item_quantity_selector.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';

/// Displays a modal bottom sheet for updating or deleting an existing item.
///
/// This bottom sheet pre-populates the fields with the details of the given `item`.
/// Users can:
/// - Adjust the item's quantity using `ItemQuantitySelector`.
/// - Edit the item's name in a `TextField`.
/// - Toggle the item's importance status.
/// - Update the item by dispatching an `UpdateItemEvent` to the `SubListBloc`.
///   An update is only allowed if the current user is an 'admin' or the creator of the item.
/// - Delete the item by showing a confirmation dialog (`showDeleteItemAlertDialog`)
///   and then dispatching a `DeleteItemEvent` to the `SubListBloc` if confirmed.
///   Deletion is also restricted to 'admin' or the item's creator.
///
/// [context] The BuildContext from which the bottom sheet is launched.
/// [item] The `ItemModel` instance whose details are to be displayed and potentially updated/deleted.

void showUpdateDeleteItemBottomSheet({
  required BuildContext context,
  required ItemModel item,
}) {
  final bloc = context.read<SubListBloc>();
  bloc.resetValues();

  bloc.itemController.text = item.title;
  bloc.number = item.quantity;
  bloc.isItemImportant = item.important;
  bloc.isItemsChecked = item.status;
  showModalBottomSheet(
    isScrollControlled: true,
    // backgroundColor: StyleColor.white,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: BlocConsumer<SubListBloc, SubListState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: context.getWidth(),
                  height: context.getHeight() * 0.46,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyleSize.sizeH24,
                      Text(
                        maxLines: 4,
                        //overflow: TextOverflow.ellipsis,
                        overflow: TextOverflow.visible,
                        bloc.itemController.text,
                        style: StyleText.bold24(context),
                      ),
                      StyleSize.sizeH16,
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: BlocBuilder<SubListBloc, SubListState>(
                              buildWhen: (previous, current) =>
                                  current is SubListLoadedState,
                              builder: (context, state) {
                                return ItemQuantitySelector();
                              },
                            ),
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
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      StyleSize.sizeH16,
                      BlocBuilder<SubListBloc, SubListState>(
                        builder: (context, state) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                context.read<SubListBloc>().add(
                                  ChooseImportanceEvent(
                                    isImportant: !bloc.isItemImportant,
                                  ),
                                );
                              },
                              icon: Icon(
                                !bloc.isItemImportant
                                    ? CupertinoIcons.exclamationmark_square
                                    : CupertinoIcons
                                          .exclamationmark_square_fill,
                                color: StyleColor.red,
                                size: context.getWidth() * .09,
                              ),
                            ),
                          );
                        },
                      ),
                      Spacer(),
                      DualActionButtonWidget(
                        isCancel: false,
                        primaryLabel: "itemUpdate".tr(),
                        onPrimaryTap: () {
                          if (bloc.itemController.text.isNotEmpty &&
                              bloc.number > 0) {
                            if (bloc.currentUserRole == "admin" ||
                                bloc.user!.userId == item.appUserId) {
                              bloc.add(UpdateItemEvent(editedItem: item));
                            }

                            Navigator.pop(context);
                          }
                        },
                        secondaryLabel: "itemDelete".tr(),
                        isDelete: true,
                        onSecondaryTap: () {
                          showDeleteItemAlertDialog(
                            context: context,
                            onDeleteConfirmed: () {
                              if (bloc.currentUserRole == "admin" ||
                                  bloc.user!.userId == item.appUserId) {
                                bloc.add(DeleteItemEvent(item: item));
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
