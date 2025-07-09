// ignore_for_file: unused_local_variable

import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> sendInvite(String email, String listId) async {
  AppUserModel? user = await fetchUserById();

  final response = await Supabase.instance.client.from('invite').insert([
    {
      'app_user_id': user!.userId,
      'receiver_email': email,
      'sender_email': user.email,
      'list_id': listId,
      'invite_status': 'pending',
    },
  ]);
}
