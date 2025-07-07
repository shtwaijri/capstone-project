import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/members/add_members/add_member_screen.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/add_item_bootomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/complete_item_bottomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/update_delete_item_bottom_sheet.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/floating_button.dart';

/// A screen that displays a list of items, allowing users to view, add,
/// (update, delete,)if item creted by them or it is admin , and admin can  mark items as completed.
///
/// This screen uses `SubListBloc` to manage its state, including loading items,
/// handling errors, and updating the UI based on item changes.
///
/// Features:
/// - **Floating Action Button**: Taps to `showAddItemBottomShaeet` to add new items.
/// - **App Bar**: Contains an icon button (currently a placeholder for adding members).
/// - **Item List**: Displays uncompleted items. If no items exist, a placeholder
///   image and text encourage adding new items. Each item can be tapped to
///   open `showUpdateDeleteItemBottomSheet` for editing or deleting.
/// - **Completion Button**: A bottom navigation bar button appears if items
///   are checked and the current user has 'admin' role. Tapping it dispatches
///   a `CheckoutEvent` and opens `completeItemBottomsheet` to finalize completion.
///
/// State Management:
/// - Uses `BlocProvider` to create and provide `SubListBloc`.
/// - Uses `BlocConsumer` for UI updates and to listen for `SubListError` states
///   to show a `SnackBar`.
/// - Uses `BlocBuilder` in the `bottomNavigationBar` to conditionally display
///   the completion button based on `isItemsChecked` and `currentUserRole`.

class SubListScreen extends StatelessWidget {
  // final String listId; //added by shatha
  // final String listName; //added by shatha
  const SubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubListBloc()..add(LoadSubListScreenData()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<SubListBloc>();
          return Scaffold(
            floatingActionButton: FloatingButton(
              onpressed: () {
                showAddItemBottomShaeet(context: context);
              },
            ),

            // appBar: AppBar(
            //   actions: [
            //     IconButton(
            //       onPressed: () {},
            //       icon: Icon(
            //         CupertinoIcons.person_crop_circle_fill_badge_plus,
            //         color: StyleColor.green,
            //       ),
            //     ),
            //   ],
            // ),
            //edited by shatha
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    final listId = GetIt.I.get<AppDatatLayer>().listId;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMemberScreen(listId: listId!),
                      ),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.person_crop_circle_fill_badge_plus,
                    color: StyleColor.green,
                  ),
                ),
              ],
            ),

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<SubListBloc, SubListState>(
                  listener: (context, state) {
                    if (state is SubListError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is SubListLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SubListLoadedState) {
                      final uncompletedItems = state.uncompletedItems;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.listName ?? "List Name".tr(),
                            style: StyleText.bold24(context),
                          ),
                          Divider(thickness: .5),
                          StyleSize.sizeH16,

                          if (uncompletedItems.isEmpty) ...[
                            StyleSize.sizeH48,
                            Image.asset("assets/images/2.png"),
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "itemNoItems1".tr(),
                                  style: StyleText.bold24(context),
                                  children: <TextSpan>[
                                    TextSpan(text: "\n"),
                                    TextSpan(
                                      text: "itemNoItems2".tr(),
                                      style: StyleText.bold24(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StyleSize.sizeH8,
                            Center(
                              child: Text(
                                "itemAdd".tr(),
                                style: StyleText.regular16Green(
                                  context,
                                ).copyWith(fontSize: 20),
                              ),
                            ),
                          ] else ...[
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: uncompletedItems.length,
                                  itemBuilder: (context, index) {
                                    ItemModel item = uncompletedItems[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showUpdateDeleteItemBottomSheet(
                                          context: context,
                                          item: item,
                                        );
                                      },
                                      child: CustomItems(
                                        itemName: item.title,
                                        numOfItems: item.quantity.toString(),
                                        createdBy: item.createdBy ?? "",
                                        isImportant: item.important,
                                        itemIndex: index,
                                        isItemChecked: item.status,
                                        itemId: item.itemId!,
                                        isCheckboxEnabled:
                                            state.currentUserRole == 'admin',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    } else if (state is SubListError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const Center(child: Text("Loading list items..."));
                  },
                ),
              ),
            ),
            bottomNavigationBar: BlocBuilder<SubListBloc, SubListState>(
              builder: (context, state) {
                if (state is SubListLoadedState) {
                  if (state.isItemsChecked &&
                      state.currentUserRole == 'admin') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtomWidget(
                        onTab: () {
                          bloc.add(CheckoutEvent());
                          // bloc.add(MarkCheckedItemsAsCompletedEvent());
                          completeItemBottomsheet(context: context);
                        },
                        textElevatedButton: "CompleteSelected".tr(),
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
