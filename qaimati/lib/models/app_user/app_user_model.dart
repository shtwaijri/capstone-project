 import 'package:dart_mappable/dart_mappable.dart';

part 'app_user_model.mapper.dart';

@MappableClass()
class AppUserModel with AppUserModelMappable {
  @MappableField(key: 'user_id')
  final String  userId;
  final String name;
  final String email;
  //  @MappableField(key: 'list_id')
  //   String? listId;
  @MappableField(key: 'created_at')
  final DateTime createdAt;

   @MappableField(key: 'auth_user_id')
  final String ? authUserId;

  AppUserModel( {
    required this.userId,
    required this.name,
    required this.email,
     
   // required this.listId,
    required this.createdAt,
    this.authUserId,
  });
}
