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

  static String? _$receiptId(ReceiptModel v) => v.receiptId;
  static const Field<ReceiptModel, String> _f$receiptId =
      Field('receiptId', _$receiptId, key: r'receipt_id', opt: true);
  static String? _$appUserId(ReceiptModel v) => v.appUserId;
  static const Field<ReceiptModel, String> _f$appUserId =
      Field('appUserId', _$appUserId, key: r'app_user_id', opt: true);
  static String _$supplier(ReceiptModel v) => v.supplier;
  static const Field<ReceiptModel, String> _f$supplier =
      Field('supplier', _$supplier);
  static String? _$date(ReceiptModel v) => v.date;
  static const Field<ReceiptModel, String> _f$date =
      Field('date', _$date, opt: true);
  static String? _$time(ReceiptModel v) => v.time;
  static const Field<ReceiptModel, String> _f$time =
      Field('time', _$time, opt: true);
  static String _$receiptNumber(ReceiptModel v) => v.receiptNumber;
  static const Field<ReceiptModel, String> _f$receiptNumber =
      Field('receiptNumber', _$receiptNumber, key: r'receipt_number');
  static double _$totalAmount(ReceiptModel v) => v.totalAmount;
  static const Field<ReceiptModel, double> _f$totalAmount =
      Field('totalAmount', _$totalAmount, key: r'total_amount');
  static String _$currency(ReceiptModel v) => v.currency;
  static const Field<ReceiptModel, String> _f$currency =
      Field('currency', _$currency);
  static String? _$receiptFileUrl(ReceiptModel v) => v.receiptFileUrl;
  static const Field<ReceiptModel, String> _f$receiptFileUrl = Field(
      'receiptFileUrl', _$receiptFileUrl,
      key: r'receipt_file_url', opt: true);
  static DateTime _$createdAt(ReceiptModel v) => v.createdAt;
  static const Field<ReceiptModel, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');

  @override
  final MappableFields<ReceiptModel> fields = const {
    #receiptId: _f$receiptId,
    #appUserId: _f$appUserId,
    #supplier: _f$supplier,
    #date: _f$date,
    #time: _f$time,
    #receiptNumber: _f$receiptNumber,
    #totalAmount: _f$totalAmount,
    #currency: _f$currency,
    #receiptFileUrl: _f$receiptFileUrl,
    #createdAt: _f$createdAt,
  };

  static ReceiptModel _instantiate(DecodingData data) {
    return ReceiptModel(
        receiptId: data.dec(_f$receiptId),
        appUserId: data.dec(_f$appUserId),
        supplier: data.dec(_f$supplier),
        date: data.dec(_f$date),
        time: data.dec(_f$time),
        receiptNumber: data.dec(_f$receiptNumber),
        totalAmount: data.dec(_f$totalAmount),
        currency: data.dec(_f$currency),
        receiptFileUrl: data.dec(_f$receiptFileUrl),
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
      String? appUserId,
      String? supplier,
      String? date,
      String? time,
      String? receiptNumber,
      double? totalAmount,
      String? currency,
      String? receiptFileUrl,
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
          {Object? receiptId = $none,
          Object? appUserId = $none,
          String? supplier,
          Object? date = $none,
          Object? time = $none,
          String? receiptNumber,
          double? totalAmount,
          String? currency,
          Object? receiptFileUrl = $none,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (receiptId != $none) #receiptId: receiptId,
        if (appUserId != $none) #appUserId: appUserId,
        if (supplier != null) #supplier: supplier,
        if (date != $none) #date: date,
        if (time != $none) #time: time,
        if (receiptNumber != null) #receiptNumber: receiptNumber,
        if (totalAmount != null) #totalAmount: totalAmount,
        if (currency != null) #currency: currency,
        if (receiptFileUrl != $none) #receiptFileUrl: receiptFileUrl,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  ReceiptModel $make(CopyWithData data) => ReceiptModel(
      receiptId: data.get(#receiptId, or: $value.receiptId),
      appUserId: data.get(#appUserId, or: $value.appUserId),
      supplier: data.get(#supplier, or: $value.supplier),
      date: data.get(#date, or: $value.date),
      time: data.get(#time, or: $value.time),
      receiptNumber: data.get(#receiptNumber, or: $value.receiptNumber),
      totalAmount: data.get(#totalAmount, or: $value.totalAmount),
      currency: data.get(#currency, or: $value.currency),
      receiptFileUrl: data.get(#receiptFileUrl, or: $value.receiptFileUrl),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  ReceiptModelCopyWith<$R2, ReceiptModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReceiptModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
