// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'list_user_role_model.dart';

class ListUserRoleModelMapper extends ClassMapperBase<ListUserRoleModel> {
  ListUserRoleModelMapper._();

  static ListUserRoleModelMapper? _instance;
  static ListUserRoleModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ListUserRoleModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ListUserRoleModel';

  static String _$listUserRoleId(ListUserRoleModel v) => v.listUserRoleId;
  static const Field<ListUserRoleModel, String> _f$listUserRoleId =
      Field('listUserRoleId', _$listUserRoleId, key: r'list_user_role_id');
  static String _$appUserId(ListUserRoleModel v) => v.appUserId;
  static const Field<ListUserRoleModel, String> _f$appUserId =
      Field('appUserId', _$appUserId, key: r'app_user_id');
  static String _$roleId(ListUserRoleModel v) => v.roleId;
  static const Field<ListUserRoleModel, String> _f$roleId =
      Field('roleId', _$roleId, key: r'role_id');
  static String _$listId(ListUserRoleModel v) => v.listId;
  static const Field<ListUserRoleModel, String> _f$listId =
      Field('listId', _$listId, key: r'list_id');
  static DateTime _$assignedAt(ListUserRoleModel v) => v.assignedAt;
  static const Field<ListUserRoleModel, DateTime> _f$assignedAt =
      Field('assignedAt', _$assignedAt, key: r'assigned_at');

  @override
  final MappableFields<ListUserRoleModel> fields = const {
    #listUserRoleId: _f$listUserRoleId,
    #appUserId: _f$appUserId,
    #roleId: _f$roleId,
    #listId: _f$listId,
    #assignedAt: _f$assignedAt,
  };

  static ListUserRoleModel _instantiate(DecodingData data) {
    return ListUserRoleModel(
        listUserRoleId: data.dec(_f$listUserRoleId),
        appUserId: data.dec(_f$appUserId),
        roleId: data.dec(_f$roleId),
        listId: data.dec(_f$listId),
        assignedAt: data.dec(_f$assignedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ListUserRoleModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ListUserRoleModel>(map);
  }

  static ListUserRoleModel fromJson(String json) {
    return ensureInitialized().decodeJson<ListUserRoleModel>(json);
  }
}

mixin ListUserRoleModelMappable {
  String toJson() {
    return ListUserRoleModelMapper.ensureInitialized()
        .encodeJson<ListUserRoleModel>(this as ListUserRoleModel);
  }

  Map<String, dynamic> toMap() {
    return ListUserRoleModelMapper.ensureInitialized()
        .encodeMap<ListUserRoleModel>(this as ListUserRoleModel);
  }

  ListUserRoleModelCopyWith<ListUserRoleModel, ListUserRoleModel,
          ListUserRoleModel>
      get copyWith =>
          _ListUserRoleModelCopyWithImpl<ListUserRoleModel, ListUserRoleModel>(
              this as ListUserRoleModel, $identity, $identity);
  @override
  String toString() {
    return ListUserRoleModelMapper.ensureInitialized()
        .stringifyValue(this as ListUserRoleModel);
  }

  @override
  bool operator ==(Object other) {
    return ListUserRoleModelMapper.ensureInitialized()
        .equalsValue(this as ListUserRoleModel, other);
  }

  @override
  int get hashCode {
    return ListUserRoleModelMapper.ensureInitialized()
        .hashValue(this as ListUserRoleModel);
  }
}

extension ListUserRoleModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ListUserRoleModel, $Out> {
  ListUserRoleModelCopyWith<$R, ListUserRoleModel, $Out>
      get $asListUserRoleModel => $base
          .as((v, t, t2) => _ListUserRoleModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ListUserRoleModelCopyWith<$R, $In extends ListUserRoleModel,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? listUserRoleId,
      String? appUserId,
      String? roleId,
      String? listId,
      DateTime? assignedAt});
  ListUserRoleModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ListUserRoleModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ListUserRoleModel, $Out>
    implements ListUserRoleModelCopyWith<$R, ListUserRoleModel, $Out> {
  _ListUserRoleModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ListUserRoleModel> $mapper =
      ListUserRoleModelMapper.ensureInitialized();
  @override
  $R call(
          {String? listUserRoleId,
          String? appUserId,
          String? roleId,
          String? listId,
          DateTime? assignedAt}) =>
      $apply(FieldCopyWithData({
        if (listUserRoleId != null) #listUserRoleId: listUserRoleId,
        if (appUserId != null) #appUserId: appUserId,
        if (roleId != null) #roleId: roleId,
        if (listId != null) #listId: listId,
        if (assignedAt != null) #assignedAt: assignedAt
      }));
  @override
  ListUserRoleModel $make(CopyWithData data) => ListUserRoleModel(
      listUserRoleId: data.get(#listUserRoleId, or: $value.listUserRoleId),
      appUserId: data.get(#appUserId, or: $value.appUserId),
      roleId: data.get(#roleId, or: $value.roleId),
      listId: data.get(#listId, or: $value.listId),
      assignedAt: data.get(#assignedAt, or: $value.assignedAt));

  @override
  ListUserRoleModelCopyWith<$R2, ListUserRoleModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ListUserRoleModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
