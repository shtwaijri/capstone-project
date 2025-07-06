import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/features/Lists/lists_screen/member_lists.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
// import 'package:qaimati/features/expenses/screens/expenses_screen.dart';
import 'package:qaimati/features/sub_list/completed_screen/completed_screen.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/empty_widget.dart';
import 'package:qaimati/widgets/floating_button.dart';

class ListsScreen extends StatelessWidget {
  ListsScreen({super.key});
  final TextEditingController addListController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // till now "fineshed select color" no binifit, maybe i need it later
      create: (_) => AddListBloc()..add(LoadListsEvent()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AddListBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: 'listTitle'.tr(),
              showActions: false,
              showSearchBar: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // ==================================== here will be external lists and completed lists ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListsButtons(
                        // cusomt widget
                        icon: Icon(Icons.check_box, color: StyleColor.green),
                        quantity: '0',
                        lable: 'completed'.tr(),
                        screen:
                            CompletedScreen(), // tis screen to go to some page
                      ),
                      ListsButtons(
                        icon: Icon(
                          Icons.people_alt_rounded,
                          color: StyleColor.blue,
                        ),
                        quantity: '0',
                        lable: 'invitedLists'.tr(),
                        screen: MemberLists(),
                      ),
                    ],
                  ),
                  // ==================================== here will end external lists and completed lists ====================
                  SizedBox(height: 16.0),
                  Divider(color: StyleColor.gray, thickness: 2.0),

                  BlocBuilder<AddListBloc, AddListState>(
                    builder: (context, state) {
                      if (state is AddListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AddListError) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is AddListLoaded) {
                        final lists = state.lists;

                        return lists.isEmpty
                            ? EmptyWidget(
                                lable: 'listNoLists'.tr(),
                                img: '',
                                hint: 'listAdd'.tr(),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: lists.length,
                                  itemBuilder: (context, index) {
                                    final list = lists[index];
                                    return GestureDetector(
                                      onLongPress: () {
                                        showAddListButtomSheet(
                                          context: context,
                                          isEdit: true,
                                        );
                                      },
                                      child: CustomListtile(
                                        title: list.name,
                                        backgroundColor: list.getColor(),
                                        onPressed: () {
                                          bloc.appGetit.listId = list.listId;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubListScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                      } else {
                        return const Center(child: Text('No state'));
                      }
                    },
                  ),
                ],
              ),
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
