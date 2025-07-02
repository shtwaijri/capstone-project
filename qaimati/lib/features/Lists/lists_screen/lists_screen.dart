import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/floating_button.dart';
// import 'package:test_befor_add/screens/show_add_list_buttom_sheet.dart';
// import 'package:test_befor_add/screens/lists/bloc/add_list_bloc.dart';
// import 'package:test_befor_add/screens/lists_buttons.dart';
// // import 'package:test_befor_add/screens/select_color.dart';
// import 'package:test_befor_add/style/style_color.dart';
// // import 'package:test_befor_add/style/style_text.dart';
// // import 'package:test_befor_add/widgets/buttom_widget.dart';
// import 'package:test_befor_add/widgets/custom_listtile.dart';
// import 'package:test_befor_add/widgets/floating_button.dart';
// import 'package:test_befor_add/widgets/text_field_widget.dart';

class ListsScreen extends StatelessWidget {
  ListsScreen({super.key});
  final TextEditingController addListController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider( // till now "fineshed select color" no binifit, maybe i need it later
      create: (context) => AddListBloc(),
      child: Builder(
        builder: (context) {
          // final bloc = context.read<AddListBloc>();
          return Scaffold(
            backgroundColor: StyleColor.white,
            appBar: AppBarWidget(title: 'Lists', showActions: false, showSearchBar: true),
            //AppBar(backgroundColor: StyleColor.white),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // TextField(
                        //   decoration: InputDecoration(
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //     ),
                        //     contentPadding: EdgeInsets.symmetric(
                        //       vertical: 10.0,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 40.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListsButtons(
                              icon: Icon(
                                Icons.check_box,
                                color: StyleColor.green,
                              ),
                              quantity: '0',
                              lable: 'completed',
                            ),
                            ListsButtons(
                              icon: Icon(
                                Icons.people_alt_rounded,
                                color: StyleColor.blue,
                              ),
                              quantity: '0',
                              lable: 'External list',
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Divider(color: StyleColor.gray, thickness: 2.0),
                      ],
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    CustomListtile(
                      title: 'title',
                      backgroundColor: StyleColor.orange,
                    ),
                    CustomListtile(
                      title: 'title',
                      backgroundColor: StyleColor.red,
                    ),
                    CustomListtile(
                      title: 'title',
                      backgroundColor: StyleColor.blue,
                    ),
                  ]),
                ),
              ],
            ),
            floatingActionButton: FloatingButton(
              onpressed: () {
                showAddListButtomSheet(context: context);
              },
            ),
          );
        },
      ),
    );
  }
}

//========================================================================================
//========================================================================================
//========================================================================================
// class ListsButtons extends StatelessWidget {
//   const ListsButtons({
//     super.key,
//     required this.icon,
//     required this.quantity,
//     required this.lable,
//   });
//   final Icon icon;
//   final String quantity;
//   final String lable;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 170,
//       height: 110,
//       decoration: BoxDecoration(
//         color: StyleColor.graylight,
//         borderRadius: BorderRadius.circular(20.0),
//         boxShadow: [
//           BoxShadow(
//             color: StyleColor.black.withValues(alpha: 0.3),
//             spreadRadius: 0.2,
//             blurRadius: 3,
//             offset: Offset(0, 4), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 icon,
//                 Text(quantity, style: StyleText.bold24(context)),
//               ],
//             ),
//             Row(children: [Text(lable, style: StyleText.bold16(context))]),
//           ],
//         ),
//       ),
//     );
//   }
// }
// EmptyWidget(lable: 'lable', img: 'assets/svg/no_items.svg', isOnboarding: false, hint: 'hint')

// class ChooseColor extends StatelessWidget {
//   const ChooseColor({super.key, required this.color});
//   final Color color;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//     );
//   }
// }























//==================================================================================================================================
//==================================================================================================================================
//==================================================================================================================================
//==================================================================================================================================

                    // showModalBottomSheet(
                    //   showDragHandle: true,
                    //   backgroundColor: StyleColor.white,
                    //   context: context,
                    //   isScrollControlled: true,
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.vertical(
                    //       top: Radius.circular(16),
                    //     ),
                    //   ),
                    //   builder: (context) {
                    //     return FractionallySizedBox(
                    //       // give buttom sheet persen size of screen
                    //       heightFactor: 0.5, // 0.5 = 50% of screen height
                    //       child: Container(
                    //         padding: const EdgeInsets.all(16.0),
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Column(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Column(
                    //                 spacing: 16,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     'Add new list',
                    //                     style: StyleText.bold16(context),
                    //                   ),
                    //                   TextFieldWidget(
                    //                     controller: addListController,
                    //                     textHint: 'List name',
                    //                   ),

                    //                   SelectColor(
                    //                     selected: bloc.selectColor,
                    //                     onTapSelect: bloc.changeColor,
                    //                   ),
                    //                 ],
                    //               ),
                    //               ButtomWidget(onTab: (){}, textElevatedButton: 'textElevatedButton')
                    //               // ElevatedButton(
                    //               //   onPressed: () {},
                    //               //   style: ElevatedButton.styleFrom(
                    //               //     backgroundColor: StyleColor.green,
                    //               //     padding: EdgeInsets.symmetric(
                    //               //       horizontal: 32,
                    //               //       vertical: 16,
                    //               //     ),
                    //               //     fixedSize: Size(
                    //               //       context.getWidth() * .9,
                    //               //       context.getHeight() * 0.06,
                    //               //     ),
                    //               //     shape: RoundedRectangleBorder(
                    //               //       borderRadius: BorderRadius.circular(10),
                    //               //     ),
                    //               //   ),
                    //               //   child: Text(
                    //               //     'Create list',
                    //               //     style: StyleText.buttonText(context),
                    //               //   ),
                    //               // ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // );