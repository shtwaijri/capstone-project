import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // دالة لجلب التنبيهات من قاعدة البيانات
  Future<List<dynamic>> _getNotifications() async {
    final response = await _supabaseClient
        .from('notification')
        .select() // تحديد الأعمدة التي نريد إرجاعها
        .eq('is_read', false)
        .order('created_at', ascending: false);

    // التحقق من وجود بيانات
    if (response != null && response.isNotEmpty) {
      return response;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: FutureBuilder<List<dynamic>>(
        future: _getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data;
          if (notifications == null || notifications.isEmpty) {
            return Center(child: Text('No new notifications.'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                title: Text(notification['title']),
                subtitle: Text(notification['body']),
                onTap: () {
                  acceptInvite(notification['list_id']);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> acceptInvite(String listId) async {
    // الكود هنا لإضافة العضو إلى اللستة بعد قبول الدعوة
  }
}
