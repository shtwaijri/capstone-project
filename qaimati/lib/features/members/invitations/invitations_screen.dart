import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/invitations/bloc/invitations_bloc.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => InvitationsBloc()..add(FetchInvitedListsEvent()),
      child: BlocBuilder<InvitationsBloc, InvitationsState>(
        builder: (context, state) {
          if (state is InviteLoadingState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is InviteLoadedState) {
            final invited = state.invitedLists;

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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  context.read<InvitationsBloc>().add(
                                    AcceptInviteEvent(inviteId: inviteId),
                                  );
                                },
                                child: const Text('Accept'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                onPressed: () {
                                  context.read<InvitationsBloc>().add(
                                    RejectInviteEvent(inviteId: inviteId),
                                  );
                                },
                                child: const Text('Reject'),
                              ),
                            ],
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
