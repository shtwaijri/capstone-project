import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubListBloc()..add(LoadSubListScreenData()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<SubListBloc>();
          //  bloc.add(LoadCompletedItemsScreenData());

          // for (var element in bloc.completedItemsMap.entries) {
          //   log("element $element");
          // }
          return Scaffold(
            appBar: AppBar(
              title: Text("Completed".tr()),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: BlocBuilder<SubListBloc, SubListState>(
              builder: (context, state) {
                if (state is SubListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SubListError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                // ⭐️ التعامل الصحيح مع حالة CompletedItemsLoadedState

                final completedItemsByListName = bloc.completedItemsMap;
                final listNames = completedItemsByListName.keys.toList();

                // if (listNames.isEmpty) {
                //   return Center(child: Text("No completed items found.".tr()));
                // }

                return ListView.builder(
                  itemCount: listNames.length,
                  itemBuilder: (context, listIndex) {
                    final listName = listNames[listIndex];
                    final itemsInThisList = completedItemsByListName[listName]!;

                    // إخفاء عنوان القائمة لو مفيش فيها عناصر مكتملة
                    if (itemsInThisList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: StyleColor.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              listName,
                              style: StyleText.bold16(
                                context,
                              ).copyWith(color: StyleColor.green),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: itemsInThisList.length,
                          itemBuilder: (context, itemInnerIndex) {
                            final item = itemsInThisList[itemInnerIndex];
                            return CustomItems(
                              checkboxColor: StyleColor.gray,
                              itemName: item.title,
                              numOfItems: item.quantity.toString(),
                              createdBy: "by ${item.createdBy ?? 'Unknown'}",
                              isImportant: item.important,
                              isItemChecked: item.isCompleted,
                              itemId: item.itemId!,
                              itemIndex: itemInnerIndex,
                              isCheckboxEnabled: false,
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  },
                );

                // // الحالة الافتراضية لأي حالة أخرى (مثل SubListInitial)
                // return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}
