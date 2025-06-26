import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/add_item_bootomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/update_delete_item%20bottom_sheet.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/floating_button.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/complete_item_bottomsheet.dart';

class SubListScreen extends StatelessWidget {
  const SubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubListBloc()..add(SubListEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<SubListBloc>();
          return Scaffold(
            floatingActionButton: FloatingButton(
              onpressed: () {
                showAddItemBottomShaeet(context: context);
              },
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
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
                  listener: (context, state) {},
                  builder: (context, state) {
                    List<ItemModel> itemsToDisplay = [];
                    int currentSelectedItemsCount = 0;

                    if (state is SubListLoadedState) {
                      itemsToDisplay = state.items;
                      currentSelectedItemsCount = state.selectedItemsCount;
                    } else if (state is SubListInitial) {
                      itemsToDisplay = [];
                      currentSelectedItemsCount = 0;
                    }

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" List Name", style: StyleText.bold24(context)),
                          Divider(thickness: .5),
                          StyleSize.sizeH16,
                          if (itemsToDisplay.isEmpty)
                            Column(
                              children: [
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
                              ],
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: itemsToDisplay.length,
                              itemBuilder: (context, index) {
                                final item = itemsToDisplay[index];
                                return GestureDetector(
                                  onTap: () {
                                    showUpdateDeleteItemBottomSheet(
                                      context: context,
                                      item: item,
                                      itemIndex: index,
                                    );
                                  },
                                  child: CustomItems(
                                    itemName: item.name,
                                    numOfItems: item.quantity.toString(),
                                    createdBy: item.createdBy,
                                    isImportant: item.isImportant,
                                    itemIndex: index,
                                    isItemChecked: item.isChecked,
                                  ),
                                );
                              },
                            ),
                          SizedBox(
                            height: currentSelectedItemsCount > 0 ? 500 : 0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            bottomNavigationBar: BlocBuilder<SubListBloc, SubListState>(
              builder: (context, state) {
                int currentSelectedItemsCount = 0;
                if (state is SubListLoadedState) {
                  currentSelectedItemsCount = state.selectedItemsCount;
                }
                return currentSelectedItemsCount > 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtomWidget(
                          onTab: () {
                            completeItemBottomsheet(context: context);
                          },
                          textElevatedButton: "CompleteSelected".tr(),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}


/**Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                8.0,
                              ),  
                              child: ButtomWidget(
                                onTab: () {
                                   
                                  completeItemBottomsheet(context: context);
                                },
                                textElevatedButton:
                                    "Complete Selected Items ", // يمكن تخصيص النص
                              ),
                            ),
                          ), */