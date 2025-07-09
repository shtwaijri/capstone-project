// THIS BY AMR

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/empty_widget.dart';
import 'package:qaimati/widgets/loading_widget.dart';

class InvitedLists extends StatelessWidget {
  const InvitedLists({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddListBloc()..add(LoadMemberListsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBarWidget(
              title: 'invitedLists'.tr(),
              showActions: true,
              showSearchBar: false,

              showBackButton: true,
            ),
            body: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ListsButtons(
                //       // cusomt widget
                //       icon: Icon(Icons.check_box, color: StyleColor.green),
                //       quantity: '0',
                //       lable: 'completed',
                //       screen:
                //           CompletedScreen(), // tis screen to go to some page
                //     ),
                //     ListsButtons(
                //       icon: Icon(
                //         Icons.people_alt_rounded,
                //         color: StyleColor.blue,
                //       ),
                //       quantity: '0',
                //       lable: 'External list',
                //       screen: ExpensesScreen(),
                //     ),
                //   ],
                // ),
                SizedBox(height: 16.0),

                // Divider(color: StyleColor.gray, thickness: 2.0),
                BlocBuilder<AddListBloc, AddListState>(
                  builder: (context, state) {
                    if (state is AddListLoading) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [LoadingWidget()],
                      );
                    } else if (state is AddListError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is AddListLoaded) {
                      final lists = state.lists;

                      // if (lists.isEmpty) {
                      //   return EmptyWidget(lable: 'No lists here', img: '');
                      // }

                      // ==================================== ADDED BY SHATHA ====================
                      // Filters out lists created by the current user to show only the ones they were invited to
                      // final allLists = state.lists;
                      // final userId = GetIt.I.get<AppDatatLayer>().userId;
                      // final filteredLists = allLists
                      //     .where((list) => list.createdAt != userId)
                      //     .toList();

                      return lists.isEmpty
                          ? EmptyWidget(
                              lable: 'no list here',
                              img: 'assets/svg/no_member.svg',
                              hint: 'add list',
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: lists.length,
                                itemBuilder: (context, index) {
                                  final list = lists[index];
                                  //THIS BY AMR
                                  // return CustomListtile(title: list.name, backgroundColor: list.getColor(),);
                                  //THIS BY SHATHA
                                  return CustomListtile(
                                    title: list.name,
                                    backgroundColor: list.getColor(),
                                    onPressed: () {
                                      GetIt.I.get<AppDatatLayer>().listId =
                                          list.listId;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SubListScreen(),
                                        ),
                                      );
                                    },
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
          );
        },
      ),
    );
  }
}
