import 'package:dart_mappable/dart_mappable.dart';
part 'receipt_api_model.mapper.dart';

@MappableClass()
/// Represents the data extracted from a receipt after being processed
/// by the Mindee API.
class ReceiptApiModel with ReceiptApiModelMappable {
  /// Supplier name
  final String supplier;

  /// Date of the receip
  final String date;

  /// Time of the receipt
  final String time;

  /// Receipt number or reference ID.
  final String receiptNumber;

  /// Total amount on the receipt.
  final double totalAmount;

  /// Currency of the amount
  final String currency;

  /// Constructor for the receipt model.
  const ReceiptApiModel({
    required this.supplier,
    required this.date,
    required this.time,
    required this.receiptNumber,
    required this.totalAmount,
    required this.currency,
  });
}
