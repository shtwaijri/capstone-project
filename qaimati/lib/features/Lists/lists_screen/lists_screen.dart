import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/buttom_sheets/show_add_list_buttom_sheet.dart';
import 'package:qaimati/features/Lists/lists_screen/invited_lists.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
import 'package:qaimati/features/members/invitations/bloc/invitations_bloc.dart';
import 'package:qaimati/features/members/invitations/invitations_screen.dart';
import 'package:qaimati/features/sub_list/completed_screen/completed_screen.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_empty_widget.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
import 'package:qaimati/widgets/custom_shimmer_effect.dart';
import 'package:qaimati/widgets/floating_button.dart';

class ListsScreen extends StatelessWidget {
  ListsScreen({super.key});
  final TextEditingController addListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddListBloc()..add(LoadListsEvent())),
        BlocProvider(
          create: (_) => InvitationsBloc()..add(FetchInvitedListsEvent()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final bloc = context.read<AddListBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: 'listTitle'.tr(),
              showActions: true,
              showSearchBar: false,

              showBackButton: false,
              actionsIcon: [
                BlocBuilder<InvitationsBloc, InvitationsState>(
                  builder: (context, state) {
                    final hasInvites =
                        state is InviteLoadedState &&
                        state.invitedLists.isNotEmpty;

                    return Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: StyleColor.green,
                            size: 26,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<InvitationsBloc>(),
                                  child: const InvitationsScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        if (hasInvites)
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.red,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            body: Column(
              children: [
                // ==================================== here will be external lists and completed lists ====================
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
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
                        screen: InvitedLists(),
                      ),
                    ],
                  ),
                ),
                // ==================================== here will end external lists and completed lists ====================
                SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Divider(color: StyleColor.gray, thickness: 2.0),
                ),

                BlocBuilder<AddListBloc, AddListState>(
                  builder: (context, state) {
                    if (state is AddListLoading) {
                      return SingleChildScrollView(
                        child: CustomShimmerEffect(isItem: false),
                      ); // while data not loaded will show shimmer (UX)
                    } else if (state is AddListError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is AddListLoaded) {
                      final lists = state.lists;

                      return lists.isEmpty
                          ? CustomEmptyWidget(
                              img: '',
                              bigText: 'listNoLists'.tr(),
                              buttonText: 'listAdd'.tr(),
                              onPressed: () {
                                showAddListButtomSheet(
                                  context: context,
                                  isEdit: false,
                                );
                              },
                            )
                          : Expanded(
                              child: BlocBuilder<AddListBloc, AddListState>(
                                builder: (context, state) {
                                  return ListView.builder(
                                    itemCount: lists.length,
                                    itemBuilder: (context, index) {
                                      final list = lists[index];
                                      return GestureDetector(
                                        onLongPress: () {
                                          // becouse on press will go to sub list
                                          showAddListButtomSheet(
                                            context: context,
                                            isEdit: true,
                                            listId: list.listId,
                                            list: list,
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
                                  );
                                },
                              ),
                            );
                    } else {
                      return CustomShimmerEffect(isItem: false);
                    }
                  },
                ),
              ],
            ),

            floatingActionButton: FloatingButton(
              onpressed: () {
                showAddListButtomSheet(
                  context: context,
                  isEdit: false,
                ); // same bottom sheet, if isEdit is false, will show add listz,);
              },
            ),
          );
        },
      ),
    );
  }
}
