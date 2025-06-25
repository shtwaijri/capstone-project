// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'sub_list_model.dart';

class SubListModelMapper extends ClassMapperBase<SubListModel> {
  SubListModelMapper._();

  static SubListModelMapper? _instance;
  static SubListModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubListModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubListModel';

  static String _$subId(SubListModel v) => v.subId;
  static const Field<SubListModel, String> _f$subId =
      Field('subId', _$subId, key: r'sub_id');
  static String _$name(SubListModel v) => v.name;
  static const Field<SubListModel, String> _f$name = Field('name', _$name);
  static String _$mainListId(SubListModel v) => v.mainListId;
  static const Field<SubListModel, String> _f$mainListId =
      Field('mainListId', _$mainListId, key: r'main_list_id');
  static DateTime _$createdAt(SubListModel v) => v.createdAt;
  static const Field<SubListModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<SubListModel> fields = const {
    #subId: _f$subId,
    #name: _f$name,
    #mainListId: _f$mainListId,
    #createdAt: _f$createdAt,
  };

  static SubListModel _instantiate(DecodingData data) {
    return SubListModel(
        subId: data.dec(_f$subId),
        name: data.dec(_f$name),
        mainListId: data.dec(_f$mainListId),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static SubListModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubListModel>(map);
  }

  static SubListModel fromJson(String json) {
    return ensureInitialized().decodeJson<SubListModel>(json);
  }
}

mixin SubListModelMappable {
  String toJson() {
    return SubListModelMapper.ensureInitialized()
        .encodeJson<SubListModel>(this as SubListModel);
  }

  Map<String, dynamic> toMap() {
    return SubListModelMapper.ensureInitialized()
        .encodeMap<SubListModel>(this as SubListModel);
  }

  SubListModelCopyWith<SubListModel, SubListModel, SubListModel> get copyWith =>
      _SubListModelCopyWithImpl<SubListModel, SubListModel>(
          this as SubListModel, $identity, $identity);
  @override
  String toString() {
    return SubListModelMapper.ensureInitialized()
        .stringifyValue(this as SubListModel);
  }

  @override
  bool operator ==(Object other) {
    return SubListModelMapper.ensureInitialized()
        .equalsValue(this as SubListModel, other);
  }

  @override
  int get hashCode {
    return SubListModelMapper.ensureInitialized()
        .hashValue(this as SubListModel);
  }
}

extension SubListModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubListModel, $Out> {
  SubListModelCopyWith<$R, SubListModel, $Out> get $asSubListModel =>
      $base.as((v, t, t2) => _SubListModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SubListModelCopyWith<$R, $In extends SubListModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? subId, String? name, String? mainListId, DateTime? createdAt});
  SubListModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SubListModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubListModel, $Out>
    implements SubListModelCopyWith<$R, SubListModel, $Out> {
  _SubListModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubListModel> $mapper =
      SubListModelMapper.ensureInitialized();
  @override
  $R call(
          {String? subId,
          String? name,
          String? mainListId,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (subId != null) #subId: subId,
        if (name != null) #name: name,
        if (mainListId != null) #mainListId: mainListId,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  SubListModel $make(CopyWithData data) => SubListModel(
      subId: data.get(#subId, or: $value.subId),
      name: data.get(#name, or: $value.name),
      mainListId: data.get(#mainListId, or: $value.mainListId),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  SubListModelCopyWith<$R2, SubListModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SubListModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
