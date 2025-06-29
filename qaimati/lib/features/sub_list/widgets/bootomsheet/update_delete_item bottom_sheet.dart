import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/alert_dialog/delete_item_alert_dialog.dart';
import 'package:qaimati/features/sub_list/widgets/button/item_quantity_selector.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';
import 'package:qaimati/widgets/update_delete_buttom_widget.dart';

void showUpdateDeleteItemBottomSheet({
  required BuildContext context,
  required ItemModel item,
  required int itemIndex,
}) {
  final bloc = context.read<SubListBloc>();

  bloc.add(LoadInitialItemDataEvent(item: item));

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: StyleColor.white,
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
                         maxLines:4 ,
                        //overflow: TextOverflow.ellipsis, 
                        overflow:TextOverflow.visible,
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
                        buildWhen: (previous, current) =>
                            current is SubListLoadedState,
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
                        isDelete: true,
                        onPrimaryTap: () {
                          if (bloc.itemController.text.isNotEmpty &&
                              bloc.number > 0) {
                            bloc.add(
                              UpdateItemEvent(
                                index: itemIndex,
                                newItemName: bloc.itemController.text,
                                newQuantity: bloc.number,
                                newIsImportant: bloc.isItemImportant,
                              ),
                            );
                            Navigator.pop(context);
                            // bloc.add(ResetBlocStateEvent());
                          } else {
                            log(
                              "Please enter item name and quantity for update",
                            );
                          }
                        },
                        primaryLabel: "itemUpdate".tr(),
                        onSecondaryTap: () {
                          showDeleteItemAlertDialog(
                            context: context,
                            onDeleteConfirmed: () {
                              bloc.add(DeleteItemEvent(index: itemIndex));
                              Navigator.pop(context);
                              bloc.add(ResetBlocStateEvent());
                            },
                          );
                        },
                        secondaryLabel: "itemDelete".tr(),
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
  ).whenComplete(() {
    bloc.add(ResetBlocStateEvent());
  });
}
