import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/completed_screen/bloc/completed_screen_bloc.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/widgets/loading_widget.dart';

/// A screen that displays a list of completed items, grouped by their original list names.
///
/// This screen fetches and displays items that have been marked as completed.
/// It uses `CompletedScreenBloc` for state management to load the data and
/// handle different states like loading, data loaded, and error.
///
/// The UI structure includes:
/// - An `AppBar` with a back button and a title localized as 'completed'.
/// - A `BlocBuilder` to react to `CompletedScreenBloc` states:
///   - Shows a `CircularProgressIndicator` during `LoadingScreenState`.
///   - Displays a message "No completed items found." if `completedItemsMap` is empty
///     in `GetDataScreenState`.
///   - Renders a `ListView.builder` to group and display completed items
///     under their respective list names when `GetDataScreenState` has data.
///     Each group features a list name and a separator, followed by `CustomItems`
///     widgets for each completed item.

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CompletedScreenBloc()..add(LoadCompletedScreen());
      },
      child: Builder(
        builder: (context) {
          final bloc = context.read<CompletedScreenBloc>();
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  bloc.close();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              title: Text("Completed".tr(), style: StyleText.bold24(context)),
            ),
            body: BlocBuilder<CompletedScreenBloc, CompletedScreenState>(
              builder: (context, state) {
                if (state is LoadingScreenState) {
                  return const Center(child: LoadingWidget());
                } else if (state is GetDataScreenState) {
                  return ListView.builder(
                    itemCount: state.completedItemsMap.keys.length,
                    itemBuilder: (context, index) {
                      String listName = state.completedItemsMap.keys.elementAt(
                        index,
                      );
                      List<ItemModel> items =
                          state.completedItemsMap[listName]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StyleSize.sizeH8,
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              listName,
                              style: StyleText.bold24(context),
                            ),
                          ),

                          Divider(color: StyleColor.gray),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              ItemModel item = items[itemIndex];
                              return CustomItems(
                                itemName: item.title,
                                numOfItems: item.quantity.toString(),
                                createdBy: item.createdBy ?? 'user',
                                isImportant: item.important,
                                itemIndex: itemIndex,
                                isItemChecked: item.isCompleted,
                                itemId: item.itemId!,
                                isCheckboxEnabled: false,
                                checkboxColor: StyleColor.gray,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (state is ErrorState) {
                  return Center(
                    child: Text('${"Error".tr()}: ${state.message}'),
                  );
                }
                return Center(child: Text("${"Initializing".tr()}..."));
              },
            ),
          );
        },
      ),
    );
  }
}
