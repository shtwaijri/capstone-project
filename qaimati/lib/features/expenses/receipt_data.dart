import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/features/expenses/repository/receipt_supabeas.dart';

class ReceiptData {
  List<ReceiptModel> receipts = [];

  Future<List<ReceiptModel>> loadDataFromSupabase() async {
    receipts = await ReceiptSupabeas(
      userId: "264db79b-d37b-4635-899c-35b582db9102",
    ).getReceipt();
    return receipts;
  }
}
