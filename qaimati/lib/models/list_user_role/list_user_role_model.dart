import 'package:dart_mappable/dart_mappable.dart';

part 'list_user_role_model.mapper.dart';

@MappableClass()
class ListUserRoleModel with ListUserRoleModelMappable {
  @MappableField(key: 'list_user_role_id')
  final String listUserRoleId;
  @MappableField(key: 'app_user_id')
  final String appUserId;
  @MappableField(key: 'role_id')
  final String roleId;
  @MappableField(key: 'list_id')
  final String listId;
  @MappableField(key: 'assigned_at')
  final DateTime assignedAt;

  ListUserRoleModel({required this.listUserRoleId, required this.appUserId, required this.roleId, required this.listId, required this.assignedAt});
}
