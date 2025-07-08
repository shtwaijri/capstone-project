import 'package:dart_mappable/dart_mappable.dart';
part 'receipt_model.mapper.dart';

/// Represents a receipt record used in the application,
/// mapped to/from JSON or database formats using dart_mappable.
@MappableClass()
class ReceiptModel with ReceiptModelMappable {
  /// Unique identifier for the receipt
  @MappableField(key: 'receipt_id')
  final String? receiptId;

  /// Identifier for the user who owns the receipt
  @MappableField(key: 'app_user_id')
  final String? appUserId;

  /// Name of the supplier/store from the receipt
  final String supplier;

  /// Date of the receipt as string
  final String? date;

  /// Time of the receipt as string
  final String? time;

  /// Receipt number or reference identifier
  @MappableField(key: 'receipt_number')
  final String receiptNumber;

  /// Total amount on the receipt
  @MappableField(key: 'total_amount')
  final double totalAmount;

  /// Currency code of the total amount
  final String currency;

  /// URL to the stored receipt image/file
  @MappableField(key: 'receipt_file_url')
  final String? receiptFileUrl;

  /// Date and time when the receipt record was created
  @MappableField(key: 'created_at')
  final DateTime createdAt;

  /// Constructor for creating a [ReceiptModel] instance.
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

  /// Maps the receipt model data to a `Map<String, dynamic>` suitable
  /// for inserting/updating in Supabase or other JSON-based storage.
  Map<String, dynamic> mapForAddSupabase() {
    return {
      'supplier': supplier,
      'date': date ?? DateTime.now().toIso8601String(),
      'time': time ?? '00:00:00',
      'receipt_number': receiptNumber,
      'total_amount': totalAmount,
      'currency': currency,
      'receipt_file_url': receiptFileUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
