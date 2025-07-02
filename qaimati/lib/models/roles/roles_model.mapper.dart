// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'roles_model.dart';

class RolesModelMapper extends ClassMapperBase<RolesModel> {
  RolesModelMapper._();

  static RolesModelMapper? _instance;
  static RolesModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RolesModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RolesModel';

  static String _$rolesId(RolesModel v) => v.rolesId;
  static const Field<RolesModel, String> _f$rolesId =
      Field('rolesId', _$rolesId, key: r'roles_id');
  static String _$name(RolesModel v) => v.name;
  static const Field<RolesModel, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<RolesModel> fields = const {
    #rolesId: _f$rolesId,
    #name: _f$name,
  };

  static RolesModel _instantiate(DecodingData data) {
    return RolesModel(rolesId: data.dec(_f$rolesId), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static RolesModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RolesModel>(map);
  }

  static RolesModel fromJson(String json) {
    return ensureInitialized().decodeJson<RolesModel>(json);
  }
}

mixin RolesModelMappable {
  String toJson() {
    return RolesModelMapper.ensureInitialized()
        .encodeJson<RolesModel>(this as RolesModel);
  }

  Map<String, dynamic> toMap() {
    return RolesModelMapper.ensureInitialized()
        .encodeMap<RolesModel>(this as RolesModel);
  }

  RolesModelCopyWith<RolesModel, RolesModel, RolesModel> get copyWith =>
      _RolesModelCopyWithImpl<RolesModel, RolesModel>(
          this as RolesModel, $identity, $identity);
  @override
  String toString() {
    return RolesModelMapper.ensureInitialized()
        .stringifyValue(this as RolesModel);
  }

  @override
  bool operator ==(Object other) {
    return RolesModelMapper.ensureInitialized()
        .equalsValue(this as RolesModel, other);
  }

  @override
  int get hashCode {
    return RolesModelMapper.ensureInitialized().hashValue(this as RolesModel);
  }
}

extension RolesModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RolesModel, $Out> {
  RolesModelCopyWith<$R, RolesModel, $Out> get $asRolesModel =>
      $base.as((v, t, t2) => _RolesModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class RolesModelCopyWith<$R, $In extends RolesModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? rolesId, String? name});
  RolesModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RolesModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RolesModel, $Out>
    implements RolesModelCopyWith<$R, RolesModel, $Out> {
  _RolesModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RolesModel> $mapper =
      RolesModelMapper.ensureInitialized();
  @override
  $R call({String? rolesId, String? name}) => $apply(FieldCopyWithData(
      {if (rolesId != null) #rolesId: rolesId, if (name != null) #name: name}));
  @override
  RolesModel $make(CopyWithData data) => RolesModel(
      rolesId: data.get(#rolesId, or: $value.rolesId),
      name: data.get(#name, or: $value.name));

  @override
  RolesModelCopyWith<$R2, RolesModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RolesModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
