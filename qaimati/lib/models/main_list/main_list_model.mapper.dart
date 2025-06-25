// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'main_list_model.dart';

class MainListModelMapper extends ClassMapperBase<MainListModel> {
  MainListModelMapper._();

  static MainListModelMapper? _instance;
  static MainListModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MainListModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MainListModel';

  static String _$id(MainListModel v) => v.id;
  static const Field<MainListModel, String> _f$id = Field('id', _$id);
  static String _$name(MainListModel v) => v.name;
  static const Field<MainListModel, String> _f$name = Field('name', _$name);
  static String _$createdAt(MainListModel v) => v.createdAt;
  static const Field<MainListModel, String> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<MainListModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #createdAt: _f$createdAt,
  };

  static MainListModel _instantiate(DecodingData data) {
    return MainListModel(
        id: data.dec(_f$id),
        name: data.dec(_f$name),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static MainListModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MainListModel>(map);
  }

  static MainListModel fromJson(String json) {
    return ensureInitialized().decodeJson<MainListModel>(json);
  }
}

mixin MainListModelMappable {
  String toJson() {
    return MainListModelMapper.ensureInitialized()
        .encodeJson<MainListModel>(this as MainListModel);
  }

  Map<String, dynamic> toMap() {
    return MainListModelMapper.ensureInitialized()
        .encodeMap<MainListModel>(this as MainListModel);
  }

  MainListModelCopyWith<MainListModel, MainListModel, MainListModel>
      get copyWith => _MainListModelCopyWithImpl<MainListModel, MainListModel>(
          this as MainListModel, $identity, $identity);
  @override
  String toString() {
    return MainListModelMapper.ensureInitialized()
        .stringifyValue(this as MainListModel);
  }

  @override
  bool operator ==(Object other) {
    return MainListModelMapper.ensureInitialized()
        .equalsValue(this as MainListModel, other);
  }

  @override
  int get hashCode {
    return MainListModelMapper.ensureInitialized()
        .hashValue(this as MainListModel);
  }
}

extension MainListModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MainListModel, $Out> {
  MainListModelCopyWith<$R, MainListModel, $Out> get $asMainListModel =>
      $base.as((v, t, t2) => _MainListModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MainListModelCopyWith<$R, $In extends MainListModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, String? createdAt});
  MainListModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MainListModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MainListModel, $Out>
    implements MainListModelCopyWith<$R, MainListModel, $Out> {
  _MainListModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MainListModel> $mapper =
      MainListModelMapper.ensureInitialized();
  @override
  $R call({String? id, String? name, String? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (name != null) #name: name,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  MainListModel $make(CopyWithData data) => MainListModel(
      id: data.get(#id, or: $value.id),
      name: data.get(#name, or: $value.name),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  MainListModelCopyWith<$R2, MainListModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _MainListModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
