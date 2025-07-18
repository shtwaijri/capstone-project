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

/// Displays a modal bottom sheet for adding a new item to a list.
///
/// This bottom sheet allows users to:
/// - Select the quantity of the item using `ItemQuantitySelector`.
/// - Enter the item's name via a `TextFormField` with validation.
/// - Mark the item as important or not.
/// - Add the item to the list by dispatching an `AddItemToListEvent` to the `SubListBloc`.
///
/// The `SubListBloc` is provided to the bottom sheet using `BlocProvider.value`
/// and its state is listened to and built using BlocBuilder`
/// to update the UI components like the quantity selector and the importance icon.
///
/// [context] The BuildContext from which the bottom sheet is launched.

void showAddItemBottomShaeet({required BuildContext context}) {
  final bloc = context.read<SubListBloc>();
  bloc.resetValues();

  showModalBottomSheet(
    isScrollControlled: true,
    // backgroundColor: StyleColor.white,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        // Changed from BlocConsumer to BlocBuilder as there's no listener logic
        child: BlocBuilder<SubListBloc, SubListState>(
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
                      StyleSize.sizeH32,
                      Text(
                        "Item".tr(),
                        style: StyleText.bold24(context).copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
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
                            child: Form(
                              key: bloc.formKey,
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "titlenotempty".tr();
                                  }
                                  return null;
                                },
                                controller: bloc.itemController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: context.getHeight() * .02,
                                    horizontal: context.getWidth() * .01,
                                  ),
                                  hintText: "itemName".tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr("asimportant"),
                                style: StyleText.bold16(context).copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),

                              Container(
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
                              ),
                            ],
                          );
                        },
                      ),
                      Spacer(),
                      ButtomWidget(
                        onTab: () {
                          if (bloc.formKey.currentState!.validate() &&
                              bloc.number >= 1) {
                            bloc.add(
                              AddItemToListEvent(
                                itemName: bloc.itemController.text,
                                quantity: bloc.number,
                                isImportant: bloc.isItemImportant,
                                createdBy: bloc.user!.email,
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
  );
}
