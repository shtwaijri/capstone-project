// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'role_model.dart';

class RoleModelMapper extends ClassMapperBase<RoleModel> {
  RoleModelMapper._();

  static RoleModelMapper? _instance;
  static RoleModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RoleModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RoleModel';

  static String _$roleId(RoleModel v) => v.roleId;
  static const Field<RoleModel, String> _f$roleId =
      Field('roleId', _$roleId, key: r'role_id');
  static String _$role(RoleModel v) => v.role;
  static const Field<RoleModel, String> _f$role = Field('role', _$role);

  @override
  final MappableFields<RoleModel> fields = const {
    #roleId: _f$roleId,
    #role: _f$role,
  };

  static RoleModel _instantiate(DecodingData data) {
    return RoleModel(roleId: data.dec(_f$roleId), role: data.dec(_f$role));
  }

  @override
  final Function instantiate = _instantiate;

  static RoleModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RoleModel>(map);
  }

  static RoleModel fromJson(String json) {
    return ensureInitialized().decodeJson<RoleModel>(json);
  }
}

mixin RoleModelMappable {
  String toJson() {
    return RoleModelMapper.ensureInitialized()
        .encodeJson<RoleModel>(this as RoleModel);
  }

  Map<String, dynamic> toMap() {
    return RoleModelMapper.ensureInitialized()
        .encodeMap<RoleModel>(this as RoleModel);
  }

  RoleModelCopyWith<RoleModel, RoleModel, RoleModel> get copyWith =>
      _RoleModelCopyWithImpl<RoleModel, RoleModel>(
          this as RoleModel, $identity, $identity);
  @override
  String toString() {
    return RoleModelMapper.ensureInitialized()
        .stringifyValue(this as RoleModel);
  }

  @override
  bool operator ==(Object other) {
    return RoleModelMapper.ensureInitialized()
        .equalsValue(this as RoleModel, other);
  }

  @override
  int get hashCode {
    return RoleModelMapper.ensureInitialized().hashValue(this as RoleModel);
  }
}

extension RoleModelValueCopy<$R, $Out> on ObjectCopyWith<$R, RoleModel, $Out> {
  RoleModelCopyWith<$R, RoleModel, $Out> get $asRoleModel =>
      $base.as((v, t, t2) => _RoleModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RoleModelCopyWith<$R, $In extends RoleModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? roleId, String? role});
  RoleModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RoleModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RoleModel, $Out>
    implements RoleModelCopyWith<$R, RoleModel, $Out> {
  _RoleModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RoleModel> $mapper =
      RoleModelMapper.ensureInitialized();
  @override
  $R call({String? roleId, String? role}) => $apply(FieldCopyWithData(
      {if (roleId != null) #roleId: roleId, if (role != null) #role: role}));
  @override
  RoleModel $make(CopyWithData data) => RoleModel(
      roleId: data.get(#roleId, or: $value.roleId),
      role: data.get(#role, or: $value.role));

  @override
  RoleModelCopyWith<$R2, RoleModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RoleModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
