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

  static DateTime _$closedAt(ItemModel v) => v.closedAt;
  static const Field<ItemModel, DateTime> _f$closedAt =
      Field('closedAt', _$closedAt, key: r'closed_at');
  static String _$itemId(ItemModel v) => v.itemId;
  static const Field<ItemModel, String> _f$itemId =
      Field('itemId', _$itemId, key: r'item_id');
  static String _$title(ItemModel v) => v.title;
  static const Field<ItemModel, String> _f$title = Field('title', _$title);
  static int _$quantity(ItemModel v) => v.quantity;
  static const Field<ItemModel, int> _f$quantity =
      Field('quantity', _$quantity);
  static String _$status(ItemModel v) => v.status;
  static const Field<ItemModel, String> _f$status = Field('status', _$status);
  static String _$subId(ItemModel v) => v.subId;
  static const Field<ItemModel, String> _f$subId =
      Field('subId', _$subId, key: r'sub_id');
  static String _$memberId(ItemModel v) => v.memberId;
  static const Field<ItemModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static DateTime _$createdAt(ItemModel v) => v.createdAt;
  static const Field<ItemModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static bool _$important(ItemModel v) => v.important;
  static const Field<ItemModel, bool> _f$important =
      Field('important', _$important);

  @override
  final MappableFields<ItemModel> fields = const {
    #closedAt: _f$closedAt,
    #itemId: _f$itemId,
    #title: _f$title,
    #quantity: _f$quantity,
    #status: _f$status,
    #subId: _f$subId,
    #memberId: _f$memberId,
    #createdAt: _f$createdAt,
    #important: _f$important,
  };

  static ItemModel _instantiate(DecodingData data) {
    return ItemModel(data.dec(_f$closedAt),
        itemId: data.dec(_f$itemId),
        title: data.dec(_f$title),
        quantity: data.dec(_f$quantity),
        status: data.dec(_f$status),
        subId: data.dec(_f$subId),
        memberId: data.dec(_f$memberId),
        createdAt: data.dec(_f$createdAt),
        important: data.dec(_f$important));
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
      {DateTime? closedAt,
      String? itemId,
      String? title,
      int? quantity,
      String? status,
      String? subId,
      String? memberId,
      DateTime? createdAt,
      bool? important});
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
          {DateTime? closedAt,
          String? itemId,
          String? title,
          int? quantity,
          String? status,
          String? subId,
          String? memberId,
          DateTime? createdAt,
          bool? important}) =>
      $apply(FieldCopyWithData({
        if (closedAt != null) #closedAt: closedAt,
        if (itemId != null) #itemId: itemId,
        if (title != null) #title: title,
        if (quantity != null) #quantity: quantity,
        if (status != null) #status: status,
        if (subId != null) #subId: subId,
        if (memberId != null) #memberId: memberId,
        if (createdAt != null) #createdAt: createdAt,
        if (important != null) #important: important
      }));
  @override
  ItemModel $make(CopyWithData data) =>
      ItemModel(data.get(#closedAt, or: $value.closedAt),
          itemId: data.get(#itemId, or: $value.itemId),
          title: data.get(#title, or: $value.title),
          quantity: data.get(#quantity, or: $value.quantity),
          status: data.get(#status, or: $value.status),
          subId: data.get(#subId, or: $value.subId),
          memberId: data.get(#memberId, or: $value.memberId),
          createdAt: data.get(#createdAt, or: $value.createdAt),
          important: data.get(#important, or: $value.important));

  @override
  ItemModelCopyWith<$R2, ItemModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ItemModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
