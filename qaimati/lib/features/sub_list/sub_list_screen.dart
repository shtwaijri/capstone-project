import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/add_item_bootomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/update_delete_item%20bottom_sheet.dart';
import 'package:qaimati/features/sub_list/widgets/button/checkout_button.dart';
import 'package:qaimati/models/item/item_model.dart'; // تأكد من وجود هذا الاستيراد
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/floating_button.dart';

class SubListScreen extends StatelessWidget {
  const SubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubListBloc()..add(LoadItemsEvent()),
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
                child: BlocBuilder<SubListBloc, SubListState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bloc.listName??"", style: StyleText.bold24(context)),
                          Divider(thickness: .5),
                          StyleSize.sizeH16,

                          // ⭐️ هنا التعديل الرئيسي: استخدام if-else مع الـ Widgets مباشرة
                          if (bloc.filteredItems.isEmpty) ...[
                            // ⭐️ استخدام if و spread operator داخل الـ children
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
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: bloc.filteredItems.length,
                              itemBuilder: (context, index) {
                                ItemModel item = bloc.filteredItems[index];
                                return GestureDetector(
                                  onTap: () {
                                    showUpdateDeleteItemBottomSheet(
                                      context: context,
                                      item: item,
                                      itemIndex: index,
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: BlocBuilder<SubListBloc, SubListState>(
              builder: (context, state) {
                final bloc = context.read<SubListBloc>();

                // ✅ الزر يظهر فقط إذا فيه عنصر محدد AND المستخدم Admin
                if (bloc.isItemsChecked && bloc.currentUserRole == 'admin') {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtomWidget(
                      onTab: () {
                        // completeItemBottomsheet(context: context);
                      },
                      textElevatedButton: "CompleteSelected".tr(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        },
      ),
    );
  }
}


 // bottomNavigationBar: BlocBuilder<SubListBloc, SubListState>(
            //   builder: (context, state) {

            //     bool currentSelectedItemsCount = false;
            //     for (var item in bloc.items) {
            //       if (item.isChecked) {
            //         currentSelectedItemsCount = true;
            //         break;
            //       }
            //     }
            //     return currentSelectedItemsCount
            //         ? Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: ButtomWidget(
            //               onTab: () {
            //                // completeItemBottomsheet(context: context);
            //               },
            //               textElevatedButton: "CompleteSelected".tr(),
            //             ),
            //           )
            //         : const SizedBox.shrink();
            //   },
            // ),