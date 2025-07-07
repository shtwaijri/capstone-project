import 'package:dart_mappable/dart_mappable.dart';

part 'invite_model.mapper.dart';

@MappableClass()
class InviteModel with InviteModelMappable {
  @MappableField(key: 'invite_id')
  final String? inviteId;

  @MappableField(key: 'app_user_id')
  final String? appUserId;

  @MappableField(key: 'list_id') // Corrected
  final String? listId;

  @MappableField(key: 'invite_status') // Corrected
  final String? inviteStatus;

  @MappableField(key: 'created_at')
  final DateTime createdAt;

  @MappableField(key: 'updated_at')
  final DateTime updatedAt;

  @MappableField(key: 'sender_email')
  final String senderEmail;

  @MappableField(key: 'receiver_email')
  final String receiverEmail;

  InviteModel({
    required this.inviteId,
    required this.appUserId,
    required this.listId,
    required this.inviteStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.senderEmail,
    required this.receiverEmail,
  });
}
