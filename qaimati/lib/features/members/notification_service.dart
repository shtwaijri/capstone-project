import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // إرسال دعوة للعضو
  Future<void> sendInvite(String userId, String email, String listId) async {
    try {
      // إضافة الدعوة إلى جدول invite
      final response = await _supabase.from('invite').insert([
        {
          'auth_user_id': userId,
          'email': email,
          'list_id': listId,
          'invite_status': 'pending',
          'created_at': DateTime.now().toString(),
        },
      ]);

      if (response.error != null) {
        print('Error sending invite: ${response.error!.message}');
      } else {
        print('Invite sent successfully!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // جلب الدعوات المعلقة للمستخدم
  Future<List<Map<String, dynamic>>> fetchInvites(String userId) async {
    try {
      final response = await _supabase
          .from('invite')
          .select('*')
          .eq('email', userId)
          .eq('invite_status', 'pending');

      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        print('No invites found');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // تحديث حالة الدعوة إلى مقبولة
  Future<void> acceptInvite(
    String inviteId,
    String userId,
    String listId,
  ) async {
    try {
      // تحديث حالة الدعوة إلى "مقبولة"
      final response = await _supabase
          .from('invite')
          .update({'invite_status': 'accepted'})
          .eq('invite_id', inviteId);

      if (response.error != null) {
        print('Error updating invite status: ${response.error!.message}');
        return;
      }

      // إضافة العضو إلى اللستة في `list_user_role`
      final roleResponse = await _supabase
          .from('roles')
          .select('roles_id')
          .eq('name', 'member')
          .single();
      final roleId = roleResponse['roles_id'];

      await _supabase.from('list_user_role').insert([
        {
          'app_user_id': userId,
          'list_id': listId,
          'role_id': roleId,
          'assigned_at': DateTime.now().toString(),
          'invite_status': 'accepted',
        },
      ]);
    } catch (e) {
      print('Error: $e');
    }
  }

  // جلب اللستات التي قبل العضو دعوتها
  Future<List<Map<String, dynamic>>> fetchLists(String userId) async {
    try {
      final response = await _supabase
          .from('list_user_role')
          .select('list_id')
          .eq('app_user_id', userId)
          .eq('invite_status', 'accepted');

      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      } else {
        print('No lists found');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
