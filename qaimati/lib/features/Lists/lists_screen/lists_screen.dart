import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
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
