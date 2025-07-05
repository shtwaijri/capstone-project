import 'package:supabase_flutter/supabase_flutter.dart';

///method to invite members
Future<void> sendInvite(String email, String listId) async {
  final response = await Supabase.instance.client.from('invite').insert([
    {
      'app_user_id': Supabase.instance.client.auth.currentUser?.id,
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

  Future<List<Map<String, dynamic>>> fetchInvitedLists() async {
    // الحصول على عميل Supabase
    final supabase = Supabase.instance.client;

    try {
      // استعلام للحصول على القوائم المدعوة
      final response = await supabase
          .from('invite')
          .select('list_id, invite_status')
          .eq('app_user_id', supabase.auth.currentUser?.id as Object)
          .eq('invite_status', 'accepted'); // فقط استعلام مباشر دون execute()

      // إرجاع البيانات مباشرة
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error: $e');
      return []; // في حال حدوث أي خطأ
    }
  }
}
