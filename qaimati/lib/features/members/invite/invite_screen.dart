// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/invite/bloc/invite_bloc.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InviteBloc()..add(FetchInvitedListsEvent()),
      child: BlocBuilder<InviteBloc, InviteState>(
        builder: (context, state) {
          if (state is InviteLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is InviteLoadedState) {
            final invited = state.invitedLists;
            final notifications = state.notifications;

            return Scaffold(
              appBar: AppBar(title: const Text('Invitations')),
              body: invited.isEmpty
                  ? const Center(child: Text("No invitations"))
                  : ListView.builder(
                      itemCount: invited.length,
                      itemBuilder: (context, index) {
                        final notification = invited[index];
                        final listName =
                            notification['list_name'] ?? 'Unknown List';
                        final senderEmail =
                            notification['sender_email'] ?? 'Unknown Sender';
                        final inviteId = notification['invite_id'];

                        return ListTile(
                          title: Text("Invitation to List: $listName"),
                          subtitle: Text(
                            "You have been invited by: $senderEmail",
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              if (inviteId != null) {
                                context.read<InviteBloc>().add(
                                  AcceptInviteEvent(inviteId: inviteId),
                                );
                              }
                            },
                            child: const Text('Accept'),
                          ),
                        );
                      },
                    ),
            );
          } else if (state is InviteErrorState) {
            return Scaffold(body: Center(child: Text(state.message)));
          } else {
            return const Scaffold(
              body: Center(child: Text("Something went wrong")),
            );
          }
        },
      ),
    );
  }
}
