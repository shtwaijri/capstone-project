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
    final listId = GetIt.I.get<AppDatatLayer>().listId;

    return BlocProvider<AddMemberBloc>(
      create: (context) =>
          AddMemberBloc()..add(FetchMembersEvent(listId: listId!)),
      child: Scaffold(
        appBar: AppBarWidget(
          title: tr("memberList"),
          showActions: true,
          showSearchBar: false,
          showBackButton: true,
        ),
        body: BlocConsumer<AddMemberBloc, AddMemberState>(
          listener: (context, state) {
            if (state is AddMemberErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AddMemberInitial || state is AddMemberLoading) {
              return Center(child: LoadingWidget());
            } else if (state is AddMemberLoadedState) {
              final members = state.members;
              return members.isEmpty
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
                              trailing: IconButton(
                                icon: Icon(
                                  CupertinoIcons.delete,
                                  color: StyleColor.red,
                                ),

                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          tr('deleteMemberConfirmation'),
                                        ),
                                        content: Text(
                                          tr('areYouSureYouWantToDeleteMember'),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(tr('cancel')),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context.read<AddMemberBloc>().add(
                                                DeleteMemberEvent(
                                                  userId: members[index],
                                                  listId: listId!,
                                                ),
                                              );
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(tr('confirm')),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
            } else {
              return Center(child: Text('Something went wrong'));
            }
          },
        ),
        floatingActionButton: FloatingButton(
          onpressed: () {
            final listId = GetIt.I.get<AppDatatLayer>().listId;

            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,

              builder: (context) => AddMemberSheetScreen(listId: listId!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
              ),
            );
          },
        ),
      ),
    );
  }
}
