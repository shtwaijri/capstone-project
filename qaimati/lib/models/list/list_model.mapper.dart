// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'list_model.dart';

class ListModelMapper extends ClassMapperBase<ListModel> {
  ListModelMapper._();

  static ListModelMapper? _instance;
  static ListModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ListModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ListModel';

  static String _$listId(ListModel v) => v.listId;
  static const Field<ListModel, String> _f$listId =
      Field('listId', _$listId, key: r'list_id');
  static String _$name(ListModel v) => v.name;
  static const Field<ListModel, String> _f$name = Field('name', _$name);
  static DateTime _$createdAt(ListModel v) => v.createdAt;
  static const Field<ListModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<ListModel> fields = const {
    #listId: _f$listId,
    #name: _f$name,
    #createdAt: _f$createdAt,
  };

  static ListModel _instantiate(DecodingData data) {
    return ListModel(
        listId: data.dec(_f$listId),
        name: data.dec(_f$name),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ListModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ListModel>(map);
  }

  static ListModel fromJson(String json) {
    return ensureInitialized().decodeJson<ListModel>(json);
  }
}

mixin ListModelMappable {
  String toJson() {
    return ListModelMapper.ensureInitialized()
        .encodeJson<ListModel>(this as ListModel);
  }

  Map<String, dynamic> toMap() {
    return ListModelMapper.ensureInitialized()
        .encodeMap<ListModel>(this as ListModel);
  }

  ListModelCopyWith<ListModel, ListModel, ListModel> get copyWith =>
      _ListModelCopyWithImpl<ListModel, ListModel>(
          this as ListModel, $identity, $identity);
  @override
  String toString() {
    return ListModelMapper.ensureInitialized()
        .stringifyValue(this as ListModel);
  }

  @override
  bool operator ==(Object other) {
    return ListModelMapper.ensureInitialized()
        .equalsValue(this as ListModel, other);
  }

  @override
  int get hashCode {
    return ListModelMapper.ensureInitialized().hashValue(this as ListModel);
  }
}

extension ListModelValueCopy<$R, $Out> on ObjectCopyWith<$R, ListModel, $Out> {
  ListModelCopyWith<$R, ListModel, $Out> get $asListModel =>
      $base.as((v, t, t2) => _ListModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ListModelCopyWith<$R, $In extends ListModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? listId, String? name, DateTime? createdAt});
  ListModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ListModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ListModel, $Out>
    implements ListModelCopyWith<$R, ListModel, $Out> {
  _ListModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ListModel> $mapper =
      ListModelMapper.ensureInitialized();
  @override
  $R call({String? listId, String? name, DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (listId != null) #listId: listId,
        if (name != null) #name: name,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ListModel $make(CopyWithData data) => ListModel(
      listId: data.get(#listId, or: $value.listId),
      name: data.get(#name, or: $value.name),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ListModelCopyWith<$R2, ListModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ListModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
