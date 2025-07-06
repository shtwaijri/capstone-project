import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/features/expenses/repository/receipt_supabeas.dart';

class ReceiptData {
  List<ReceiptModel> allReceipts = [];
  List<ReceiptModel> monthlyReceipts = [];
  Future<List<ReceiptModel>> loadAllDataFromSupabase() async {
    allReceipts = await ReceiptSupabase().getAllReceipt();
    return allReceipts;
  }

  Future<List<ReceiptModel>> loadMonthlyDataFromSupabase({
    required int year,
    required int month,
  }) async {
    allReceipts = await ReceiptSupabase().getMonthlyReceipts(
      year: year,
      month: month,
    );
    return allReceipts;
  }
}
