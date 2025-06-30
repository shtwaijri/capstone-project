import 'package:dart_mappable/dart_mappable.dart';

part 'roles_model.mapper.dart';

@MappableClass()


class RolesModel with RolesModelMappable {
  @MappableField(key: 'roles_id')
  final String rolesId;
  final String name;

  RolesModel({required this.rolesId, required this.name});
}