// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'activity_model.dart';

class ActivityModelMapper extends ClassMapperBase<ActivityModel> {
  ActivityModelMapper._();

  static ActivityModelMapper? _instance;
  static ActivityModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ActivityModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ActivityModel';

  static String _$actitvityId(ActivityModel v) => v.actitvityId;
  static const Field<ActivityModel, String> _f$actitvityId =
      Field('actitvityId', _$actitvityId, key: r'actitvity_id');
  static String _$memberId(ActivityModel v) => v.memberId;
  static const Field<ActivityModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static String _$action(ActivityModel v) => v.action;
  static const Field<ActivityModel, String> _f$action =
      Field('action', _$action);
  static String _$itemId(ActivityModel v) => v.itemId;
  static const Field<ActivityModel, String> _f$itemId =
      Field('itemId', _$itemId, key: r'item_id');
  static DateTime _$createdAt(ActivityModel v) => v.createdAt;
  static const Field<ActivityModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<ActivityModel> fields = const {
    #actitvityId: _f$actitvityId,
    #memberId: _f$memberId,
    #action: _f$action,
    #itemId: _f$itemId,
    #createdAt: _f$createdAt,
  };

  static ActivityModel _instantiate(DecodingData data) {
    return ActivityModel(
        actitvityId: data.dec(_f$actitvityId),
        memberId: data.dec(_f$memberId),
        action: data.dec(_f$action),
        itemId: data.dec(_f$itemId),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ActivityModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ActivityModel>(map);
  }

  static ActivityModel fromJson(String json) {
    return ensureInitialized().decodeJson<ActivityModel>(json);
  }
}

mixin ActivityModelMappable {
  String toJson() {
    return ActivityModelMapper.ensureInitialized()
        .encodeJson<ActivityModel>(this as ActivityModel);
  }

  Map<String, dynamic> toMap() {
    return ActivityModelMapper.ensureInitialized()
        .encodeMap<ActivityModel>(this as ActivityModel);
  }

  ActivityModelCopyWith<ActivityModel, ActivityModel, ActivityModel>
      get copyWith => _ActivityModelCopyWithImpl<ActivityModel, ActivityModel>(
          this as ActivityModel, $identity, $identity);
  @override
  String toString() {
    return ActivityModelMapper.ensureInitialized()
        .stringifyValue(this as ActivityModel);
  }

  @override
  bool operator ==(Object other) {
    return ActivityModelMapper.ensureInitialized()
        .equalsValue(this as ActivityModel, other);
  }

  @override
  int get hashCode {
    return ActivityModelMapper.ensureInitialized()
        .hashValue(this as ActivityModel);
  }
}

extension ActivityModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ActivityModel, $Out> {
  ActivityModelCopyWith<$R, ActivityModel, $Out> get $asActivityModel =>
      $base.as((v, t, t2) => _ActivityModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ActivityModelCopyWith<$R, $In extends ActivityModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? actitvityId,
      String? memberId,
      String? action,
      String? itemId,
      DateTime? createdAt});
  ActivityModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ActivityModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ActivityModel, $Out>
    implements ActivityModelCopyWith<$R, ActivityModel, $Out> {
  _ActivityModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ActivityModel> $mapper =
      ActivityModelMapper.ensureInitialized();
  @override
  $R call(
          {String? actitvityId,
          String? memberId,
          String? action,
          String? itemId,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (actitvityId != null) #actitvityId: actitvityId,
        if (memberId != null) #memberId: memberId,
        if (action != null) #action: action,
        if (itemId != null) #itemId: itemId,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ActivityModel $make(CopyWithData data) => ActivityModel(
      actitvityId: data.get(#actitvityId, or: $value.actitvityId),
      memberId: data.get(#memberId, or: $value.memberId),
      action: data.get(#action, or: $value.action),
      itemId: data.get(#itemId, or: $value.itemId),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ActivityModelCopyWith<$R2, ActivityModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ActivityModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
