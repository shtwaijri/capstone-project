// services/list_service.dart
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> createList(String name, int color, String userId) async {
  if (userId.isEmpty) {
    print('Error: User ID is empty.');
    return;
  }

  final response = await Supabase.instance.client.from('list').insert([
    {'name': name, 'color': color, 'created_by': userId},
  ]);

  if (response.error != null) {
    print('Error creating list: ${response.error?.message}');
  } else {
    print('List created successfully');
  }
}

Future<void> createAdminRole() async {
  final response = await Supabase.instance.client.from('roles').insert([
    {'name': 'admin'},
  ]);

  if (response.error != null) {
    print('Error creating admin role: ${response.error?.message}');
  } else {
    print('Admin role created successfully');
  }
}

Future<void> addUserToList(String listId, String userId, String roleId) async {
  final response = await Supabase.instance.client.from('list_user_role').insert(
    [
      {'app_user_id': userId, 'list_id': listId, 'role_id': roleId},
    ],
  );

  if (response.error != null) {
    print('Error adding user to list: ${response.error?.message}');
  } else {
    print('User added to list with role successfully');
  }

  Future<void> sendInviteNotification(String userId, String listId) async {
    final response = await Supabase.instance.client.from('notification').insert([
      {
        'app_user_id': userId, // الـ user المدعو
        'title': 'You have been invited!',
        'body':
            'You are invited to join a shopping list. Accept the invitation to join.',
        'is_read': false, // تعني أن الدعوة لم تُقرأ بعد
        'notification_id_new':
            'invite-${DateTime.now().millisecondsSinceEpoch}', // معرف فريد
      },
    ]);

    if (response.error != null) {
      print('Error sending invite notification: ${response.error?.message}');
    } else {
      print('Invite notification sent successfully');
    }
  }

  Future<void> acceptInvite(String listId, String userId) async {
    final response = await Supabase.instance.client
        .from('list_user_role')
        .insert([
          {
            'app_user_id': userId,
            'list_id': listId,
            'role_id': 'role_id_for_member', // تعيين الدور (مثال: عضو)
          },
        ]);

    if (response.error != null) {
      print('Error accepting invite: ${response.error?.message}');
    } else {
      print('Invite accepted successfully');
    }

    // تأكد من وضع علامة على التنبيه بأنه قد تم قراءته
    final updateResponse = await Supabase.instance.client
        .from('notification')
        .update({'is_read': true})
        .eq('notification_id', listId);

    if (updateResponse.error != null) {
      print('Error updating notification: ${updateResponse.error?.message}');
    }
  }
}
