// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'member_role_model.dart';

class MemberRoleModelMapper extends ClassMapperBase<MemberRoleModel> {
  MemberRoleModelMapper._();

  static MemberRoleModelMapper? _instance;
  static MemberRoleModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MemberRoleModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MemberRoleModel';

  static String _$memberRoleId(MemberRoleModel v) => v.memberRoleId;
  static const Field<MemberRoleModel, String> _f$memberRoleId =
      Field('memberRoleId', _$memberRoleId, key: r'member_role_id');
  static String _$memberId(MemberRoleModel v) => v.memberId;
  static const Field<MemberRoleModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static String _$roleId(MemberRoleModel v) => v.roleId;
  static const Field<MemberRoleModel, String> _f$roleId =
      Field('roleId', _$roleId, key: r'role_id');
  static DateTime _$assignedAt(MemberRoleModel v) => v.assignedAt;
  static const Field<MemberRoleModel, DateTime> _f$assignedAt =
      Field('assignedAt', _$assignedAt, key: r'assigned_at');

  @override
  final MappableFields<MemberRoleModel> fields = const {
    #memberRoleId: _f$memberRoleId,
    #memberId: _f$memberId,
    #roleId: _f$roleId,
    #assignedAt: _f$assignedAt,
  };

  static MemberRoleModel _instantiate(DecodingData data) {
    return MemberRoleModel(
        memberRoleId: data.dec(_f$memberRoleId),
        memberId: data.dec(_f$memberId),
        roleId: data.dec(_f$roleId),
        assignedAt: data.dec(_f$assignedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static MemberRoleModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MemberRoleModel>(map);
  }

  static MemberRoleModel fromJson(String json) {
    return ensureInitialized().decodeJson<MemberRoleModel>(json);
  }
}

mixin MemberRoleModelMappable {
  String toJson() {
    return MemberRoleModelMapper.ensureInitialized()
        .encodeJson<MemberRoleModel>(this as MemberRoleModel);
  }

  Map<String, dynamic> toMap() {
    return MemberRoleModelMapper.ensureInitialized()
        .encodeMap<MemberRoleModel>(this as MemberRoleModel);
  }

  MemberRoleModelCopyWith<MemberRoleModel, MemberRoleModel, MemberRoleModel>
      get copyWith =>
          _MemberRoleModelCopyWithImpl<MemberRoleModel, MemberRoleModel>(
              this as MemberRoleModel, $identity, $identity);
  @override
  String toString() {
    return MemberRoleModelMapper.ensureInitialized()
        .stringifyValue(this as MemberRoleModel);
  }

  @override
  bool operator ==(Object other) {
    return MemberRoleModelMapper.ensureInitialized()
        .equalsValue(this as MemberRoleModel, other);
  }

  @override
  int get hashCode {
    return MemberRoleModelMapper.ensureInitialized()
        .hashValue(this as MemberRoleModel);
  }
}

extension MemberRoleModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MemberRoleModel, $Out> {
  MemberRoleModelCopyWith<$R, MemberRoleModel, $Out> get $asMemberRoleModel =>
      $base.as((v, t, t2) => _MemberRoleModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MemberRoleModelCopyWith<$R, $In extends MemberRoleModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? memberRoleId,
      String? memberId,
      String? roleId,
      DateTime? assignedAt});
  MemberRoleModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MemberRoleModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MemberRoleModel, $Out>
    implements MemberRoleModelCopyWith<$R, MemberRoleModel, $Out> {
  _MemberRoleModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MemberRoleModel> $mapper =
      MemberRoleModelMapper.ensureInitialized();
  @override
  $R call(
          {String? memberRoleId,
          String? memberId,
          String? roleId,
          DateTime? assignedAt}) =>
      $apply(FieldCopyWithData({
        if (memberRoleId != null) #memberRoleId: memberRoleId,
        if (memberId != null) #memberId: memberId,
        if (roleId != null) #roleId: roleId,
        if (assignedAt != null) #assignedAt: assignedAt
      }));
  @override
  MemberRoleModel $make(CopyWithData data) => MemberRoleModel(
      memberRoleId: data.get(#memberRoleId, or: $value.memberRoleId),
      memberId: data.get(#memberId, or: $value.memberId),
      roleId: data.get(#roleId, or: $value.roleId),
      assignedAt: data.get(#assignedAt, or: $value.assignedAt));

  @override
  MemberRoleModelCopyWith<$R2, MemberRoleModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MemberRoleModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
