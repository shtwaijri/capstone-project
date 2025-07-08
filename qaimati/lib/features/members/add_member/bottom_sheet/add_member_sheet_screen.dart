import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/add_member/bloc/add_member_sheet_bloc.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';

class AddMemberSheetScreen extends StatelessWidget {
  final String listId;

  const AddMemberSheetScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMemberBloc(),
      child: BlocConsumer<AddMemberBloc, AddMemberState>(
        listener: (context, state) {
          if (state is AddMemberSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('invite has sent successfully')),
            );
          } else if (state is AddMemberFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
          }
        },
        builder: (context, state) {
          final bloc = context.read<AddMemberBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: tr('memberAddTitle'),
              showActions: true,
              showSearchBar: false,
              showBackButton: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: tr("emailHint")),
                    onChanged: (value) {
                      bloc.add(AddEmailEvent(value));
                    },
                  ),
                  SizedBox(height: 20),

                  state is AddMemberLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            bloc.add(
                              SendInviteEvent(
                                email: bloc.email,
                                listId: listId,
                              ),
                            );
                          },
                          child: Text(tr("memberAddTitle")),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
