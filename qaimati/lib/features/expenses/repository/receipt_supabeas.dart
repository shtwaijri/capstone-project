import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/repository/supabase.dart';

class ReceiptSupabeas {
  // SupabaseConnect.supabase
  //     ?.from('app_user')
  //     .select('user_id')
  //     .eq('user_id', "264db79b-d37b-4635-899c-35b582db9102");

  final String userId;
  ReceiptSupabeas({required this.userId});
  addNewReceipt({required ReceiptModel receipt}) async {
    final user = await SupabaseConnect.getUser(userId);
    if (user == null) throw Exception("User not found");

    await SupabaseConnect.supabase
        ?.from('receipt')
        .insert(receipt.mapForAddSupabase());
  }

  Future<List<ReceiptModel>> getReceipt() async {
    final user = await SupabaseConnect.getUser(userId);
    if (user == null) throw Exception("User not found");

    final allData = await SupabaseConnect.supabase
        ?.from('receipt')
        .select("*")
        .eq('app_user_id', user.userId);
    if (allData == null || allData.isEmpty) {
      return [];
    }
    return allData.map((receipt) {
      return ReceiptModelMapper.fromMap(receipt);
    }).toList();
  }

  // updateReceipt() async {
  //   final user = await SupabaseConnect.getUser(
  //     "264db79b-d37b-4635-899c-35b582db9102",
  //   );
  //   if (user == null) throw Exception("User not found");

  //   final allData = await SupabaseConnect.supabase?.from('receipt');
  //   // .update()
  //   // .eq('receipt_id', receiptId)
  //   // .eq('app_user_id', userId);
  //   if (allData == null || allData.isEmpty) {
  //     return [];
  //   }
  //   return allData.map((receipt) {
  //     return ReceiptModelMapper.fromMap(receipt);
  //   }).toList();
  // }
}
