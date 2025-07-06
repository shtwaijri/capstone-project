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
  final response = await Supabase.instance.client.from('invite').insert([
    {
      'app_user_id': fetchUserById(),
      'email': email,
      'list_id': listId,
      'invite_status': 'pending',
    },
  ]);

  //method for accepting the invite(update the invite table)

  Future<void> acceptInvite(String inviteId) async {
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

    try {
      final response = await supabase
          .from('invite')
          .select('list_id, invite_status')
          .eq('app_user_id', fetchUserById)
          .eq('invite_status', 'accepted');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error: $e');
    }
  }

  return null;
}
