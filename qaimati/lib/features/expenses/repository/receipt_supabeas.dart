import 'dart:typed_data';
import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

class ReceiptSupabase {
  Future<void> checkAddReceiptEligibility() async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final appUser = await SupabaseConnect.supabase!
        .from('app_user')
        .select('is_prime')
        .eq('user_id', user.userId)
        .maybeSingle();

    final receipts = await SupabaseConnect.supabase!
        .from('receipt')
        .select('receipt_id')
        .eq('app_user_id', user.userId);

    bool isPrime = false;
    if (appUser != null && appUser['is_prime'] == true) {
      isPrime = true;
    }

    if (!isPrime && receipts.length >= 3) {
      throw Exception(
        "وصلت للحد الأقصى (3 فواتير). اشترك في برايم لإضافة المزيد.",
      );
    }
  }

  Future<void> addNewReceipt({required ReceiptModel receipt}) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    await SupabaseConnect.supabase?.from('receipt').insert({
      ...receipt.mapForAddSupabase(),
      'app_user_id': user.userId,
    });
  }

  Future<List<ReceiptModel>> getAllReceipt() async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final allData = await SupabaseConnect.supabase
        ?.from('receipt')
        .select("*")
        .eq('app_user_id', user.userId);
    if (allData == null || allData.isEmpty) {
      return [];
    }
    try {
      return allData.map((receipt) {
        return ReceiptModelMapper.fromMap(receipt);
      }).toList();
    } catch (e) {
      throw Exception("Failed to parse receipt data: $e");
    }
  }

  Future<List<ReceiptModel>> updateReceipt(
    Map<String, dynamic> updatedData,
    String receiptId,
  ) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final allData = await SupabaseConnect.supabase!
        .from('receipt')
        .update(updatedData)
        .eq('receipt_id', receiptId)
        .eq('app_user_id', user.userId)
        .select();

    if (allData.isEmpty) {
      return [];
    }

    return allData.map<ReceiptModel>((receipt) {
      return ReceiptModelMapper.fromMap(receipt);
    }).toList();
  }

  Future<void> deleteReceipt(String receiptId) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    try {
      final response = await SupabaseConnect.supabase!
          .from('receipt')
          .delete()
          .eq('receipt_id', receiptId)
          .eq('app_user_id', user.userId);

      print("Delete response: $response");

      return;
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }

  Future<String> uploadReceiptToStorage({
    required Uint8List receiptData,
  }) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final time = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${user.userId}/$time.png';

    final response = await SupabaseConnect.supabase!.storage
        .from('receipt')
        .uploadBinary(filePath, receiptData);

    if (response.isEmpty) throw Exception("Upload failed");

    return SupabaseConnect.supabase!.storage
        .from('receipt')
        .getPublicUrl(filePath);
  }

  Future<double> getMonthlyTotalAmount({
    required int year,
    required int month,
  }) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final startDate = DateTime(year, month, 1);
    final endDate = (month < 12)
        ? DateTime(year, month + 1, 1)
        // .subtract(const Duration(seconds: 1))
        : DateTime(year + 1, 1, 1);
    // .subtract(const Duration(seconds: 1));

    final allData = await SupabaseConnect.supabase!
        .from('receipt')
        .select('total_amount')
        .eq('app_user_id', user.userId)
        .gte('date', startDate.toIso8601String())
        .lte('date', endDate.toIso8601String());

    if (allData.isEmpty) return 0;

    double total = 0;
    for (final item in allData) {
      final amount = item['total_amount'];
      if (amount != null) {
        total += double.tryParse(amount.toString()) ?? 0;
      }
    }

    return total;
  }

  Future<List<ReceiptModel>> getMonthlyReceipts({
    required int year,
    required int month,
  }) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    final startDate = DateTime(year, month, 1);
    final endDate = (month < 12)
        ? DateTime(year, month + 1, 1).subtract(const Duration(seconds: 1))
        : DateTime(year + 1, 1, 1).subtract(const Duration(seconds: 1));

    final allData = await SupabaseConnect.supabase
        ?.from('receipt')
        .select("*")
        .eq('app_user_id', user.userId)
        .gte('date', startDate.toIso8601String())
        .lte('date', endDate.toIso8601String());

    if (allData == null || allData.isEmpty) {
      return [];
    }

    return allData.map((receipt) {
      return ReceiptModelMapper.fromMap(receipt);
    }).toList();
  }
}
