import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';

import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/empty_widget.dart';

class MemberLists extends StatelessWidget {
  const MemberLists({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddListBloc()..add(LoadMemberListsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBarWidget(
              title: 'externalList'.tr(),
              showActions: true,
              showSearchBar: false,
              actionsIcon: [
                Icon(Icons.notification_add_rounded, color: StyleColor.green),
              ],
            ),
            body: Column(
              children: [
                SizedBox(height: 16.0),

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
                              lable: 'no list here',
                              img: '',
                              hint: 'add list',
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: lists.length,
                                itemBuilder: (context, index) {
                                  final list = lists[index];
                                  return CustomListtile(
                                    title: list.name,
                                    backgroundColor: list.getColor(),
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
