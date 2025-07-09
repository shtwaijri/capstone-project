import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/add_member/bloc/add_member_bloc.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/loading_widget.dart';

class AddMemberSheetScreen extends StatelessWidget {
  final String listId;

  const AddMemberSheetScreen({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AddMemberBloc>(),
      child: BlocConsumer<AddMemberBloc, AddMemberState>(
        listener: (context, state) {
          if (state is AddMemberSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(tr('InviteSnackBar'))));
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
                  // TextField with border and styling
                  TextField(
                    decoration: InputDecoration(
                      hintText: tr("emailHint"),
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white54
                              : Colors.black54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                    ),
                    onChanged: (value) {
                      bloc.add(AddEmailEvent(value));
                    },
                  ),
                  SizedBox(height: 20),

                  // Button with black text color
                  state is AddMemberLoading
                      ? LoadingWidget()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            bloc.add(
                              SendInviteEvent(
                                email: bloc.email,
                                listId: listId,
                              ),
                            );
                          },
                          child: Text(
                            tr("memberAddTitle"),
                            style: TextStyle(color: Colors.black),
                          ),
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
