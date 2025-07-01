// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'receipt_api_model.dart';

class ReceiptApiModelMapper extends ClassMapperBase<ReceiptApiModel> {
  ReceiptApiModelMapper._();

  static ReceiptApiModelMapper? _instance;
  static ReceiptApiModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReceiptApiModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReceiptApiModel';

  static String _$supplier(ReceiptApiModel v) => v.supplier;
  static const Field<ReceiptApiModel, String> _f$supplier =
      Field('supplier', _$supplier);
  static String _$date(ReceiptApiModel v) => v.date;
  static const Field<ReceiptApiModel, String> _f$date = Field('date', _$date);
  static String _$time(ReceiptApiModel v) => v.time;
  static const Field<ReceiptApiModel, String> _f$time = Field('time', _$time);
  static String _$receiptNumber(ReceiptApiModel v) => v.receiptNumber;
  static const Field<ReceiptApiModel, String> _f$receiptNumber =
      Field('receiptNumber', _$receiptNumber);
  static double _$totalAmount(ReceiptApiModel v) => v.totalAmount;
  static const Field<ReceiptApiModel, double> _f$totalAmount =
      Field('totalAmount', _$totalAmount);
  static String _$currency(ReceiptApiModel v) => v.currency;
  static const Field<ReceiptApiModel, String> _f$currency =
      Field('currency', _$currency);

  @override
  final MappableFields<ReceiptApiModel> fields = const {
    #supplier: _f$supplier,
    #date: _f$date,
    #time: _f$time,
    #receiptNumber: _f$receiptNumber,
    #totalAmount: _f$totalAmount,
    #currency: _f$currency,
  };

  static ReceiptApiModel _instantiate(DecodingData data) {
    return ReceiptApiModel(
        supplier: data.dec(_f$supplier),
        date: data.dec(_f$date),
        time: data.dec(_f$time),
        receiptNumber: data.dec(_f$receiptNumber),
        totalAmount: data.dec(_f$totalAmount),
        currency: data.dec(_f$currency));
  }

  @override
  final Function instantiate = _instantiate;

  static ReceiptApiModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReceiptApiModel>(map);
  }

  static ReceiptApiModel fromJson(String json) {
    return ensureInitialized().decodeJson<ReceiptApiModel>(json);
  }
}

mixin ReceiptApiModelMappable {
  String toJson() {
    return ReceiptApiModelMapper.ensureInitialized()
        .encodeJson<ReceiptApiModel>(this as ReceiptApiModel);
  }

  Map<String, dynamic> toMap() {
    return ReceiptApiModelMapper.ensureInitialized()
        .encodeMap<ReceiptApiModel>(this as ReceiptApiModel);
  }

  ReceiptApiModelCopyWith<ReceiptApiModel, ReceiptApiModel, ReceiptApiModel>
      get copyWith =>
          _ReceiptApiModelCopyWithImpl<ReceiptApiModel, ReceiptApiModel>(
              this as ReceiptApiModel, $identity, $identity);
  @override
  String toString() {
    return ReceiptApiModelMapper.ensureInitialized()
        .stringifyValue(this as ReceiptApiModel);
  }

  @override
  bool operator ==(Object other) {
    return ReceiptApiModelMapper.ensureInitialized()
        .equalsValue(this as ReceiptApiModel, other);
  }

  @override
  int get hashCode {
    return ReceiptApiModelMapper.ensureInitialized()
        .hashValue(this as ReceiptApiModel);
  }
}

extension ReceiptApiModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReceiptApiModel, $Out> {
  ReceiptApiModelCopyWith<$R, ReceiptApiModel, $Out> get $asReceiptApiModel =>
      $base.as((v, t, t2) => _ReceiptApiModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReceiptApiModelCopyWith<$R, $In extends ReceiptApiModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? supplier,
      String? date,
      String? time,
      String? receiptNumber,
      double? totalAmount,
      String? currency});
  ReceiptApiModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _ReceiptApiModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReceiptApiModel, $Out>
    implements ReceiptApiModelCopyWith<$R, ReceiptApiModel, $Out> {
  _ReceiptApiModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReceiptApiModel> $mapper =
      ReceiptApiModelMapper.ensureInitialized();
  @override
  $R call(
          {String? supplier,
          String? date,
          String? time,
          String? receiptNumber,
          double? totalAmount,
          String? currency}) =>
      $apply(FieldCopyWithData({
        if (supplier != null) #supplier: supplier,
        if (date != null) #date: date,
        if (time != null) #time: time,
        if (receiptNumber != null) #receiptNumber: receiptNumber,
        if (totalAmount != null) #totalAmount: totalAmount,
        if (currency != null) #currency: currency
      }));
  @override
  ReceiptApiModel $make(CopyWithData data) => ReceiptApiModel(
      supplier: data.get(#supplier, or: $value.supplier),
      date: data.get(#date, or: $value.date),
      time: data.get(#time, or: $value.time),
      receiptNumber: data.get(#receiptNumber, or: $value.receiptNumber),
      totalAmount: data.get(#totalAmount, or: $value.totalAmount),
      currency: data.get(#currency, or: $value.currency));

  @override
  ReceiptApiModelCopyWith<$R2, ReceiptApiModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReceiptApiModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
