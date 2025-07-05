class Notification {
  final String id;
  final String title;
  final String body;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
  });

  // تحويل البيانات من Supabase (JSON) إلى كائن Dart
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['notification_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      isRead: json['is_read'] ?? false,
    );
  }
}
