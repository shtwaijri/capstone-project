import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/add_member/bloc/add_member_bloc.dart';
import 'package:qaimati/features/members/add_member/bottom_sheet/add_member_sheet_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_empty_widget.dart';
import 'package:qaimati/widgets/floating_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/widgets/loading_widget.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //get the listId from appdatalayer
    final listId = GetIt.I.get<AppDatatLayer>().listId;
    //addmemberbloc member is responsible for handling member states like adding and deleting
    return BlocProvider<AddMemberBloc>(
      create: (context) =>
          //we use (..) to call the method after the contructor called
          AddMemberBloc()..add(FetchMembersEvent(listId: listId!)),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AddMemberBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: tr("memberList"),
              showActions: true,
              showSearchBar: false,
              showBackButton: true,
            ),
            body: BlocConsumer<AddMemberBloc, AddMemberState>(
              //the listner listen for changes in the bloc states
              listener: (context, state) {
                if (state is AddMemberErrorState) {
                  // if the state is an error state, show a SnackBar with the error message.
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                //when the addmember in the initial stae or loading, show the loading widget
                if (state is AddMemberInitial || state is AddMemberLoading) {
                  return Center(child: LoadingWidget());
                } else if (state is AddMemberLoadedState) {
                  // extract the list of members from the current state
                  final members = state.members;
                  return members.isEmpty
                      //show an empty widget if there wasn't any member
                      ? Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            CustomEmptyWidget(
                              img: 'assets/svg/no_member.svg',
                              bigText: tr('memberNoMembers'),
                              buttonText: tr('memberAddTitle'),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) =>
                                      AddMemberSheetScreen(listId: listId!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(100),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : ListView.builder(
                          //number of members to display
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  title: Text(
                                    members[index],
                                    style: StyleText.bold16(context),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ],
                            );
                          },
                        );
                } else if (state is AddMemberSuccess) {
                  return Center(child: LoadingWidget());
                }
                return Center(child: Text('Something went wrong'));
              },
            ),
            floatingActionButton: FloatingButton(
              onpressed: () {
                final listId = GetIt.I.get<AppDatatLayer>().listId;
                log("log lis id ${listId}");

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,

                  builder: (context) => AddMemberSheetScreen(listId: listId!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(100),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
