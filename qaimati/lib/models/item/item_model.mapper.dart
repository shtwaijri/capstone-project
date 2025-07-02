// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'item_model.dart';

class ItemModelMapper extends ClassMapperBase<ItemModel> {
  ItemModelMapper._();

  static ItemModelMapper? _instance;
  static ItemModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ItemModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ItemModel';

  static String? _$createdBy(ItemModel v) => v.createdBy;
  static const Field<ItemModel, String> _f$createdBy =
      Field('createdBy', _$createdBy, key: r'created_by', opt: true);
  static bool _$important(ItemModel v) => v.important;
  static const Field<ItemModel, bool> _f$important =
      Field('important', _$important);
  static bool _$isCompleted(ItemModel v) => v.isCompleted;
  static const Field<ItemModel, bool> _f$isCompleted =
      Field('isCompleted', _$isCompleted, key: r'is_completed');
  static String? _$itemId(ItemModel v) => v.itemId;
  static const Field<ItemModel, String> _f$itemId =
      Field('itemId', _$itemId, key: r'item_id', opt: true);
  static String _$title(ItemModel v) => v.title;
  static const Field<ItemModel, String> _f$title = Field('title', _$title);
  static int _$quantity(ItemModel v) => v.quantity;
  static const Field<ItemModel, int> _f$quantity =
      Field('quantity', _$quantity);
  static bool _$status(ItemModel v) => v.status;
  static const Field<ItemModel, bool> _f$status = Field('status', _$status);
  static String _$listId(ItemModel v) => v.listId;
  static const Field<ItemModel, String> _f$listId =
      Field('listId', _$listId, key: r'list');
  static String _$appUserId(ItemModel v) => v.appUserId;
  static const Field<ItemModel, String> _f$appUserId =
      Field('appUserId', _$appUserId, key: r'app_user_id');
  static DateTime? _$createdAt(ItemModel v) => v.createdAt;
  static const Field<ItemModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);
  static DateTime? _$closedAt(ItemModel v) => v.closedAt;
  static const Field<ItemModel, DateTime> _f$closedAt =
      Field('closedAt', _$closedAt, key: r'closed_at', opt: true);

  @override
  final MappableFields<ItemModel> fields = const {
    #createdBy: _f$createdBy,
    #important: _f$important,
    #isCompleted: _f$isCompleted,
    #itemId: _f$itemId,
    #title: _f$title,
    #quantity: _f$quantity,
    #status: _f$status,
    #listId: _f$listId,
    #appUserId: _f$appUserId,
    #createdAt: _f$createdAt,
    #closedAt: _f$closedAt,
  };

  static ItemModel _instantiate(DecodingData data) {
    return ItemModel(
        createdBy: data.dec(_f$createdBy),
        important: data.dec(_f$important),
        isCompleted: data.dec(_f$isCompleted),
        itemId: data.dec(_f$itemId),
        title: data.dec(_f$title),
        quantity: data.dec(_f$quantity),
        status: data.dec(_f$status),
        listId: data.dec(_f$listId),
        appUserId: data.dec(_f$appUserId),
        createdAt: data.dec(_f$createdAt),
        closedAt: data.dec(_f$closedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ItemModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ItemModel>(map);
  }

  static ItemModel fromJson(String json) {
    return ensureInitialized().decodeJson<ItemModel>(json);
  }
}

mixin ItemModelMappable {
  String toJson() {
    return ItemModelMapper.ensureInitialized()
        .encodeJson<ItemModel>(this as ItemModel);
  }

  Map<String, dynamic> toMap() {
    return ItemModelMapper.ensureInitialized()
        .encodeMap<ItemModel>(this as ItemModel);
  }

  ItemModelCopyWith<ItemModel, ItemModel, ItemModel> get copyWith =>
      _ItemModelCopyWithImpl<ItemModel, ItemModel>(
          this as ItemModel, $identity, $identity);
  @override
  String toString() {
    return ItemModelMapper.ensureInitialized()
        .stringifyValue(this as ItemModel);
  }

  @override
  bool operator ==(Object other) {
    return ItemModelMapper.ensureInitialized()
        .equalsValue(this as ItemModel, other);
  }

  @override
  int get hashCode {
    return ItemModelMapper.ensureInitialized().hashValue(this as ItemModel);
  }
}

extension ItemModelValueCopy<$R, $Out> on ObjectCopyWith<$R, ItemModel, $Out> {
  ItemModelCopyWith<$R, ItemModel, $Out> get $asItemModel =>
      $base.as((v, t, t2) => _ItemModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ItemModelCopyWith<$R, $In extends ItemModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? createdBy,
      bool? important,
      bool? isCompleted,
      String? itemId,
      String? title,
      int? quantity,
      bool? status,
      String? listId,
      String? appUserId,
      DateTime? createdAt,
      DateTime? closedAt});
  ItemModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ItemModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ItemModel, $Out>
    implements ItemModelCopyWith<$R, ItemModel, $Out> {
  _ItemModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ItemModel> $mapper =
      ItemModelMapper.ensureInitialized();
  @override
  $R call(
          {Object? createdBy = $none,
          bool? important,
          bool? isCompleted,
          Object? itemId = $none,
          String? title,
          int? quantity,
          bool? status,
          String? listId,
          String? appUserId,
          Object? createdAt = $none,
          Object? closedAt = $none}) =>
      $apply(FieldCopyWithData({
        if (createdBy != $none) #createdBy: createdBy,
        if (important != null) #important: important,
        if (isCompleted != null) #isCompleted: isCompleted,
        if (itemId != $none) #itemId: itemId,
        if (title != null) #title: title,
        if (quantity != null) #quantity: quantity,
        if (status != null) #status: status,
        if (listId != null) #listId: listId,
        if (appUserId != null) #appUserId: appUserId,
        if (createdAt != $none) #createdAt: createdAt,
        if (closedAt != $none) #closedAt: closedAt
      }));
  @override
  ItemModel $make(CopyWithData data) => ItemModel(
      createdBy: data.get(#createdBy, or: $value.createdBy),
      important: data.get(#important, or: $value.important),
      isCompleted: data.get(#isCompleted, or: $value.isCompleted),
      itemId: data.get(#itemId, or: $value.itemId),
      title: data.get(#title, or: $value.title),
      quantity: data.get(#quantity, or: $value.quantity),
      status: data.get(#status, or: $value.status),
      listId: data.get(#listId, or: $value.listId),
      appUserId: data.get(#appUserId, or: $value.appUserId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      closedAt: data.get(#closedAt, or: $value.closedAt));

  @override
  ItemModelCopyWith<$R2, ItemModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ItemModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
