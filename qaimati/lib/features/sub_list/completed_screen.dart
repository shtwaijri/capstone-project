import 'package:flutter/material.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';

class CompletedScreen extends StatelessWidget {
  CompletedScreen({super.key});

  final List<Map<String, dynamic>> completedListsData = [
    {
      'listName': 'قائمة الأسبوع الأول',
      'items': [
        ItemModel(
          name: 'تفاح',
          quantity: 3,
          createdBy: 'أحمد',
          isImportant: false,
          isChecked: true,
        ),
        ItemModel(
          name: 'خبز',
          quantity: 1,
          createdBy: 'فاطمة',
          isImportant: true,
          isChecked: true,
        ),
        ItemModel(
          name: 'حليب',
          quantity: 2,
          createdBy: 'علي',
          isImportant: false,
          isChecked: true,
        ),
      ],
    },
    {
      'listName': 'مستلزمات الحفلة',
      'items': [
        ItemModel(
          name: 'زينة',
          quantity: 5,
          createdBy: 'سارة',
          isImportant: false,
          isChecked: true,
        ),
        ItemModel(
          name: 'بالونات',
          quantity: 20,
          createdBy: 'محمد',
          isImportant: true,
          isChecked: true,
        ),
        ItemModel(
          name: 'كعكة',
          quantity: 1,
          createdBy: 'نور',
          isImportant: false,
          isChecked: true,
        ),
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: completedListsData.length,
          itemBuilder: (context, listIndex) {
            final listData = completedListsData[listIndex];
            final String listName = listData['listName'];
            final List<ItemModel> items = listData['items']
                .cast<ItemModel>();  

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.getWidth() * 0.05,
                    vertical: context.getHeight() * 0.02,
                  ),
                  child: Text(
                    listName,
                    style: StyleText.bold16(context),  
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, itemIndex) {
                    final item = items[itemIndex];
                    return CustomItems(
                      itemName: item.name,
                      numOfItems: item.quantity
                          .toString(), 
                      createdBy: item.createdBy,
                      isImportant: item.isImportant,
                      itemIndex:
                          itemIndex, 
                      isItemChecked:
                          item.isChecked, 
                      isCheckboxEnabled:
                          false, 
                    );
                  },
                ),
                 
              ],
            );
          },
        ),
      ),
    );
  }
}
