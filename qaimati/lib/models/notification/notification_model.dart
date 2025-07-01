import 'package:dart_mappable/dart_mappable.dart';

part 'notification_model.mapper.dart';

@MappableClass()
class NotificationModel with NotificationModelMappable {
  @MappableField(key: 'notification_id')
  final String notificationId;
  @MappableField(key: 'app_user_id')
  final String appUserId;
  final String title;
  final String body;
  @MappableField(key: 'is_read')
  final bool isRead;

  @MappableField(key: 'created_at')
  final DateTime createdAt;

  NotificationModel({required this.notificationId, required this.appUserId, required this.title, required this.body, required this.isRead, required this.createdAt});
}
