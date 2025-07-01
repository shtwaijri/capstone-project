// <<<<<<< Shatha-Altwaij
// import 'package:flutter/material.dart';
// import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';
// import 'package:qaimati/style/style_text.dart';
// import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
// =======
// >>>>>>> dev-main



// import 'package:flutter/material.dart';

// class CompletedScreen extends StatelessWidget {
//   const CompletedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
// <<<<<<< Shatha-Altwaij
//       body: SafeArea(
//         child: ListView.builder(
//           itemCount: completedListsData.length,
//           itemBuilder: (context, listIndex) {
//             final listData = completedListsData[listIndex];
//             final String listName = listData['listName'];
//             final List<ItemModel> items = listData['items'].cast<ItemModel>();

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: context.getWidth() * 0.05,
//                     vertical: context.getHeight() * 0.02,
//                   ),
//                   child: Text(listName, style: StyleText.bold16(context)),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: items.length,
//                   itemBuilder: (context, itemIndex) {
//                     final item = items[itemIndex];
//                     return CustomItems(
//                       itemName: item.name,
//                       numOfItems: item.quantity.toString(),
//                       createdBy: item.createdBy,
//                       isImportant: item.isImportant,
//                       itemIndex: itemIndex,
//                       isItemChecked: item.isChecked,
//                       isCheckboxEnabled: false,
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         ),
// =======
//       body: Center(
//         child: Text("CompletedScreen"),
// >>>>>>> dev-main
//       ),
//     );
//   }
// }