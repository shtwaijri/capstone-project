import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
import 'package:qaimati/features/expenses/screens/expenses_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/floating_button.dart';

class ListsScreen extends StatelessWidget {
  ListsScreen({super.key});
  final TextEditingController addListController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // till now "fineshed select color" no binifit, maybe i need it later
      create: (context) => AddListBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: StyleColor.white,
            appBar: AppBarWidget(
              title: 'Lists',
              showActions: false,
              showSearchBar: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // ==================================== here will be external lists and completed lists ====================
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListsButtons( // cusomt widget 
                              icon: Icon(
                                Icons.check_box,
                                color: StyleColor.green,
                              ),
                              quantity: '0',
                              lable: 'completed',
                              screen: ExpensesScreen(), // tis screen to go to some page
                            ),
                            ListsButtons(
                              icon: Icon(
                                Icons.people_alt_rounded,
                                color: StyleColor.blue,
                              ),
                              quantity: '0',
                              lable: 'External list',
                              screen: ExpensesScreen(),
                            ),
                          ],
                        ),
                        // ==================================== here will end external lists and completed lists ====================
                        SizedBox(height: 16.0),
                        Divider(color: StyleColor.gray, thickness: 2.0),
                      ],
                    ),
                  ),
                ),

                SliverList( // why sliver? cause i have 2 sections, one for external lists and one for completed lists, and th eother one for my list
                  delegate: SliverChildListDelegate([ // need to convert to SliverChildBuilderDelegate(...) when get date form database,
                    GestureDetector(
                      onLongPress: () {
                        // every one will contain to type press, onPress and onLongPress
                        // onpress ot go to items screen (sublistScreen), onLongPress ot edit or delete list
                        showAddListButtomSheet(
                          context: context,
                          isEdit: true,
                        ); // same bottom sheet, if isEdit is true, will show edit list
                      },
                      child: CustomListtile(
                        title: 'title',
                        backgroundColor: StyleColor.orange,
                      ),
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
                showAddListButtomSheet(
                  context: context,
                  isEdit: false,
                ); // same bottom sheet, if isEdit is false, will show add list
              },
            ),
          );
        },
      ),
    );
  }
}
