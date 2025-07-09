import 'package:qaimati/models/receipt/receipt_model.dart';
import 'package:qaimati/repository/receipt_repository/receipt_supabeas.dart';

/// A helper class to manage loading and storing receipt data from Supabase.
class ReceiptData {
  /// A list that holds all receipt records from the database.
  List<ReceiptModel> allReceipts = [];

  /// A list that holds receipts for a specific month and year.
  List<ReceiptModel> monthlyReceipts = [];

  /// Loads all receipts from Supabase and stores them in [allReceipts].
  ///
  /// Returns the full list of receipts.
  Future<List<ReceiptModel>> loadAllDataFromSupabase() async {
    allReceipts = await ReceiptSupabase().getAllReceipt();
    return allReceipts;
  }

  /// Loads monthly receipts based on the given [year] and [month].
  ///
  /// Returns the list of filtered monthly receipts.
  Future<List<ReceiptModel>> loadMonthlyDataFromSupabase({
    required int year,
    required int month,
  }) async {
    monthlyReceipts = await ReceiptSupabase().getMonthlyReceipts(
      year: year,
      month: month,
    );
    return monthlyReceipts;
  }
}
