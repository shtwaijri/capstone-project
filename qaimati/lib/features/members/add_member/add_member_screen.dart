import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/add_member_sheet/add_member_sheet_screen.dart';
import 'package:qaimati/features/members/add_member_sheet/bloc/add_member_sheet_bloc.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_empty_widget.dart';
import 'package:qaimati/widgets/floating_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/app_data.dart';

class AddMemberScreen extends StatelessWidget {
  const AddMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listId = GetIt.I.get<AppDatatLayer>().listId;

    return BlocProvider(
      create: (context) =>
          AddMemberBloc()..add(FetchMembersEvent(listId: listId!)),
      child: BlocConsumer<AddMemberBloc, AddMemberState>(
        listener: (context, state) {
          if (state is AddMemberErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AddMemberInitial) {
            return Scaffold(
              appBar: AppBarWidget(
                title: tr("memberList"),
                showActions: true,
                showSearchBar: false,
              ),
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is AddMemberLoadedState) {
            final members = state.members;

            return Scaffold(
              appBar: AppBarWidget(
                title: tr("memberList"),
                showActions: true,
                showSearchBar: false,
              ),
              body: members.isEmpty
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
                        return ListTile(title: Text(members[index]));
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
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(100),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Scaffold(body: Center(child: Text('Something went wrong')));
          }
        },
      ),
    );
  }
}
