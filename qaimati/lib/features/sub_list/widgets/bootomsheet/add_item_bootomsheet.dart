import 'dart:developer';

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

void showAddItemBottomShaeet({required BuildContext context}) {
  final bloc = context.read<SubListBloc>();

  bloc.add(ResetBlocStateEvent());
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: StyleColor.white,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: BlocConsumer<SubListBloc, SubListState>(
          listener: (context, state) {
            if (state is SubListLoadedState) {}
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  width: context.getWidth(),
                  height: context.getHeight() * 0.7,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StyleSize.sizeH32,
                      Text("Item", style: StyleText.bold24(context)),
                      StyleSize.sizeH16,
                      Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: BlocBuilder<SubListBloc, SubListState>(
                              buildWhen: (previous, current) =>
                                  current is SubListLoadedState,
                              builder: (context, state) {
                                int currentQuantity = 0;
                                if (state is SubListLoadedState) {
                                  currentQuantity = state.currentNumber;
                                }
                                return ItemQuantitySelector(
                                  number: currentQuantity,
                                );
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
                          bool currentIsImportant = false;
                          if (state is SubListLoadedState) {
                            currentIsImportant = state.currentIsItemImportant;
                          }
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                context.read<SubListBloc>().add(
                                  ChooseImportanceEvent(
                                    isImportant: !currentIsImportant,
                                  ),
                                );
                              },
                              icon: Icon(
                                !currentIsImportant
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
                      ButtomWidget(
                        onTab: () {
                          if (bloc.itemController.text.isNotEmpty &&
                              bloc.number >= 1) {
                            bloc.add(
                              AddItemToListEvent(
                                itemName: bloc.itemController.text,
                                quantity: bloc.number,
                                isImportant: bloc.isItemImportant,
                                createdBy: "You",
                              ),
                            );
                            Navigator.pop(context);
                          }  
                        },
                        textElevatedButton: "itemAdd".tr(),
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
