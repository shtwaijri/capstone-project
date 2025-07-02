import 'package:dart_mappable/dart_mappable.dart';
part 'receipt_model.mapper.dart';

@MappableClass()
class ReceiptModel with ReceiptModelMappable {
  @MappableField(key: 'receipt_id')
  final String? receiptId;
  @MappableField(key: 'app_user_id')
  final String? appUserId;
  final String supplier;
  final String? date;
  final String? time;
  @MappableField(key: 'receipt_number')
  final String receiptNumber;
  @MappableField(key: 'total_amount')
  final double totalAmount;
  final String currency;
  @MappableField(key: 'receipt_file_url')
  final String? receiptFileUrl;
  @MappableField(key: 'created_at')
  final DateTime createdAt;

  ReceiptModel({
    this.receiptId,
    this.appUserId,
    required this.supplier,
    this.date,
    this.time,
    required this.receiptNumber,
    required this.totalAmount,
    required this.currency,
    this.receiptFileUrl,
    required this.createdAt,
  });
  Map<String, dynamic> mapForAddSupabase() {
    return {
      'supplier': supplier,
      'date': date ?? '2019-11-02',
      'time': time ?? '00:00:00',
      'receipt_number': receiptNumber,
      'total_amount': totalAmount,
      'currency': currency,
      'receipt_file_url': receiptFileUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
