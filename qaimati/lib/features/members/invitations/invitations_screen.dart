// ignore_for_file: unused_field

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/invitations/bloc/invite_bloc.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:qaimati/models/invite_model/invite_model.dart';

// ignore: must_be_immutable
class InvitationsScreen extends StatelessWidget {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  List<InviteModel> inviteNoti = [];

  List<Map<String, dynamic>> invited = [];

  InvitationsScreen({super.key});

  Future<void> checkMyRole(String listId) async {
    final user = await fetchUserById();
    final response = await Supabase.instance.client
        .from('list_user_role')
        .select('role_id, role:roles(name)')
        .eq('list_id', listId)
        .eq('app_user_id', user!.userId)
        .single();

    final roleName = response['role']['name'];
    print('$roleName');
  }

  ////////////////////////////////////////////////////////
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
              appBar: AppBar(title: const Text('Notifications')),
              body: invited.isEmpty
                  ? const Center(child: Text("No invitations"))
                  : ListView.builder(
                      itemCount: invited.length,
                      itemBuilder: (context, index) {
                        final notification = invited[index];
                        final listId =
                            notification['list_id'] ?? 'Unknown List';
                        final senderEmail =
                            notification['sender_email'] ?? 'Unknown Sender';
                        final inviteId = notification['invite_id'] as String?;
                        final listInfo =
                            notification['list'] as Map<String, dynamic>?;
                        final listName = listInfo?['name'] ?? 'Unknown List';

                        return ListTile(
                          title: Text("Invitation to List: $listName"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("You have been invited by: $senderEmail"),
                            ],
                          ),
                          trailing: inviteId != null
                              ? ElevatedButton(
                                  onPressed: () =>
                                      context.read<InviteBloc>().add(
                                        AcceptInviteEvent(inviteId: inviteId),
                                      ),
                                  child: const Text('Accept'),
                                )
                              : null,
                        );
                      },
                    ),
            );
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
