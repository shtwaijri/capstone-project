// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'receipt_model.dart';

class ReceiptModelMapper extends ClassMapperBase<ReceiptModel> {
  ReceiptModelMapper._();

  static ReceiptModelMapper? _instance;
  static ReceiptModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReceiptModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReceiptModel';

  static String _$receiptId(ReceiptModel v) => v.receiptId;
  static const Field<ReceiptModel, String> _f$receiptId =
      Field('receiptId', _$receiptId, key: r'receipt_id');
  static String _$itemId(ReceiptModel v) => v.itemId;
  static const Field<ReceiptModel, String> _f$itemId =
      Field('itemId', _$itemId, key: r'item_id');
  static String _$memberId(ReceiptModel v) => v.memberId;
  static const Field<ReceiptModel, String> _f$memberId =
      Field('memberId', _$memberId, key: r'member_id');
  static double _$total(ReceiptModel v) => v.total;
  static const Field<ReceiptModel, double> _f$total = Field('total', _$total);
  static String _$receiptImageUrl(ReceiptModel v) => v.receiptImageUrl;
  static const Field<ReceiptModel, String> _f$receiptImageUrl =
      Field('receiptImageUrl', _$receiptImageUrl, key: r'receipt_image_url');
  static DateTime _$createdAt(ReceiptModel v) => v.createdAt;
  static const Field<ReceiptModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<ReceiptModel> fields = const {
    #receiptId: _f$receiptId,
    #itemId: _f$itemId,
    #memberId: _f$memberId,
    #total: _f$total,
    #receiptImageUrl: _f$receiptImageUrl,
    #createdAt: _f$createdAt,
  };

  static ReceiptModel _instantiate(DecodingData data) {
    return ReceiptModel(
        receiptId: data.dec(_f$receiptId),
        itemId: data.dec(_f$itemId),
        memberId: data.dec(_f$memberId),
        total: data.dec(_f$total),
        receiptImageUrl: data.dec(_f$receiptImageUrl),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static ReceiptModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReceiptModel>(map);
  }

  static ReceiptModel fromJson(String json) {
    return ensureInitialized().decodeJson<ReceiptModel>(json);
  }
}

mixin ReceiptModelMappable {
  String toJson() {
    return ReceiptModelMapper.ensureInitialized()
        .encodeJson<ReceiptModel>(this as ReceiptModel);
  }

  Map<String, dynamic> toMap() {
    return ReceiptModelMapper.ensureInitialized()
        .encodeMap<ReceiptModel>(this as ReceiptModel);
  }

  ReceiptModelCopyWith<ReceiptModel, ReceiptModel, ReceiptModel> get copyWith =>
      _ReceiptModelCopyWithImpl<ReceiptModel, ReceiptModel>(
          this as ReceiptModel, $identity, $identity);
  @override
  String toString() {
    return ReceiptModelMapper.ensureInitialized()
        .stringifyValue(this as ReceiptModel);
  }

  @override
  bool operator ==(Object other) {
    return ReceiptModelMapper.ensureInitialized()
        .equalsValue(this as ReceiptModel, other);
  }

  @override
  int get hashCode {
    return ReceiptModelMapper.ensureInitialized()
        .hashValue(this as ReceiptModel);
  }
}

extension ReceiptModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReceiptModel, $Out> {
  ReceiptModelCopyWith<$R, ReceiptModel, $Out> get $asReceiptModel =>
      $base.as((v, t, t2) => _ReceiptModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReceiptModelCopyWith<$R, $In extends ReceiptModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? receiptId,
      String? itemId,
      String? memberId,
      double? total,
      String? receiptImageUrl,
      DateTime? createdAt});
  ReceiptModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReceiptModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReceiptModel, $Out>
    implements ReceiptModelCopyWith<$R, ReceiptModel, $Out> {
  _ReceiptModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReceiptModel> $mapper =
      ReceiptModelMapper.ensureInitialized();
  @override
  $R call(
          {String? receiptId,
          String? itemId,
          String? memberId,
          double? total,
          String? receiptImageUrl,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (receiptId != null) #receiptId: receiptId,
        if (itemId != null) #itemId: itemId,
        if (memberId != null) #memberId: memberId,
        if (total != null) #total: total,
        if (receiptImageUrl != null) #receiptImageUrl: receiptImageUrl,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ReceiptModel $make(CopyWithData data) => ReceiptModel(
      receiptId: data.get(#receiptId, or: $value.receiptId),
      itemId: data.get(#itemId, or: $value.itemId),
      memberId: data.get(#memberId, or: $value.memberId),
      total: data.get(#total, or: $value.total),
      receiptImageUrl: data.get(#receiptImageUrl, or: $value.receiptImageUrl),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ReceiptModelCopyWith<$R2, ReceiptModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReceiptModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
