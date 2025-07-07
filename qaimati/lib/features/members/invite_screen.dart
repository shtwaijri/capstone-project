import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qaimati/features/members/invite_model/invite_model.dart';
import 'package:qaimati/features/members/service.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/list_user_role/list_user_role_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InviteScreen extends StatefulWidget {
  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  List<InviteModel> inviteNoti = [];
  List<Map<String, dynamic>> invited = [];

  @override
  void initState() {
    super.initState();
    _getNotifications();
    fetchInvitedLists();
    log("list: $fetchInvitedLists()");
  }

  // Fetch all invited lists
  //this method has a problem
  //it's send the invite fol all users
  // Future<void> fetchInvitedLists() async {
  //   final supabase = Supabase.instance.client;
  //   AppUserModel? user = await fetchUserById();

  //   try {
  //     final response = await supabase
  //         .from('invite')
  //         .select(
  //           'list_id, invite_status, app_user_id, sender_email, invite_id',
  //         ); // Ensure invite_id and sender_email are selected

  //     invited = List<Map<String, dynamic>>.from(response);
  //     setState(() {});
  //   } catch (e) {
  //     log('Error fetching invited lists: $e');
  //   }
  // }

  Future<void> fetchInvitedLists() async {
    final supabase = Supabase.instance.client;
    AppUserModel? user = await fetchUserById();

    try {
      final response = await supabase
          .from('invite')
          .select(
            'list_id, invite_status, app_user_id, sender_email, invite_id, list(name)',
          )
          .eq('receiver_email', user!.email)
          .order('created_at', ascending: false);

      invited = List<Map<String, dynamic>>.from(response);
      setState(() {});
    } catch (e) {
      log('Error fetching invited lists: $e');
    }
  }

  // Fetch notifications for the user, filtered by the receiver's email
  Future<void> _getNotifications() async {
    AppUserModel? user = await fetchUserById();

    log("User Email: ${user!.email}");

    final response = await _supabaseClient
        .from('invite')
        .select()
        .eq('app_user_id', user.userId)
        .order('created_at', ascending: false);

    log("Notifications response: ${response.toString()}");

    if (response != null && response.isNotEmpty) {
      setState(() {
        inviteNoti = response.map<InviteModel>((listNoti) {
          return InviteModelMapper.fromMap(listNoti);
        }).toList();
      });
    } else {
      log("No invitations found for ${user.email}");
    }
  }

  Future<void> _acceptInvite(String inviteId) async {
    try {
      final updatedInvite = await _supabaseClient
          .from('invite')
          .update({'invite_status': 'accepted'})
          .eq('invite_id', inviteId)
          .select()
          .single();

      log("Invite accepted: $updatedInvite");

      AppUserModel? user = await fetchUserById();

      final roleId = await SupabaseConnect.getRoleIdByName("member");

      await _supabaseClient.from('list_user_role').insert({
        'app_user_id': user!.userId,
        'list_id': updatedInvite['list_id'],
        'role_id': roleId,
      });

      log(
        "Role assigned to user ${user.userId} in list ${updatedInvite['list_id']}",
      );
      await checkMyRole(updatedInvite['list_id']);

      // ✅ Step 5: Refresh UI
      await _getNotifications();
      await fetchInvitedLists();
    } catch (e) {
      log('error accepting invite: $e');
    }
  }

  Future<void> checkMyRole(String listId) async {
    final user = await fetchUserById();
    final response = await Supabase.instance.client
        .from('list_user_role')
        .select('role_id, role:roles(name)')
        .eq('list_id', listId)
        .eq('app_user_id', user!.userId)
        .single();

    final roleName = response['role']['name'];
    print(' دور اليوزر في القائمة: $roleName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: invited.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading state
          : ListView.builder(
              itemCount: invited.length,
              itemBuilder: (context, index) {
                final notification = invited[index];
                // Safely access values, providing a default if null
                final listId = notification['list_id'] ?? 'Unknown List';
                final senderEmail =
                    notification['sender_email'] ?? 'Unknown Sender';
                final inviteId =
                    notification['invite_id'] as String?; // Get the invite_id

                final listInfo = notification['list'] as Map<String, dynamic>?;
                final listName = listInfo?['name'] ?? 'Unknown List';

                return ListTile(
                  title: Text("Invitation to List: $listName"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text("You have been invited by: $senderEmail")],
                  ),
                  trailing: inviteId != null
                      ? ElevatedButton(
                          onPressed: () => _acceptInvite(inviteId),
                          child: Text('Accept'),
                        )
                      : null, // Don't show button if inviteId is null
                );
              },
            ),
    );
  }
}
