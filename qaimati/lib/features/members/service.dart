import 'dart:developer';

import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///method to invite members
// Future<void> sendInvite(String email, String listId) async {
//   final response = await Supabase.instance.client.from('invite').insert([
//     {
//       'app_user_id': fetchUserById(),
//       'email': email,
//       'list_id': listId,
//       'invite_status': 'pending',
//     },
//   ]);
Future<void> sendInvite(String email, String listId) async {
  AppUserModel? user = await fetchUserById();
  log("start sendInvite $email $listId");

  final response = await Supabase.instance.client.from('invite').insert([
    {
      'app_user_id': user!.userId,
      'receiver_email': email,
      'sender_email': user.email,
      'list_id': listId,
      'invite_status': 'pending',
    },
  ]);

  log("response${response.toString()}");
}

//method for accepting the invite(update the invite table)

Future<void> acceptInvite(String inviteId) async {
  AppUserModel? user = await fetchUserById();

  final response = await Supabase.instance.client
      .from('invite')
      .update({'invite_status': 'accepted'})
      .eq('invite_id', inviteId);
}

//method for rejecting the invite(update the invite table)

Future<void> rejectInvite(String inviteId) async {
  final response = await Supabase.instance.client
      .from('invite')
      .update({'invite_status': 'rejected'})
      .eq('invite_id', inviteId);
}

Future<List<Map<String, dynamic>>?> fetchInvitedLists() async {
  final supabase = Supabase.instance.client;
  AppUserModel? user = await fetchUserById();

  try {
    final response = await supabase
        .from('invite')
        .select('list_id, invite_status')
        .select('user_id, app_user(email)');

    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    log('Error: $e');
  }
  return null;
}
