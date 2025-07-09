// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

/// Repository class to handle all Supabase interactions related to receipts.
///
/// This includes:
/// - Adding, updating, deleting, and retrieving receipts.
/// - Uploading receipt images to Supabase Storage.
/// - Enforcing free-tier limits (non-Prime users can only add 3 receipts).
class ReceiptSupabase {
  /// Checks if the current user is eligible to add a new receipt.
  ///
  /// Non-Prime users are limited to a maximum of 3 receipts.
  /// Throws an exception if user not found or limit is exceeded.
  Future<void> checkAddReceiptEligibility() async {
    try {
      final user = await fetchUserById();
      if (user == null) throw Exception("User not found");

      // Check if the user has Prime subscription
      final appUser = await SupabaseConnect.supabase!
          .from('app_user')
          .select('is_prime')
          .eq('user_id', user.userId)
          .maybeSingle();
      // Count existing receipts for the user
      final receipts = await SupabaseConnect.supabase!
          .from('receipt')
          .select('receipt_id')
          .eq('app_user_id', user.userId);

      bool isPrime = false;
      if (appUser != null && appUser['is_prime'] == true) {
        isPrime = true;
      }
      // If user is not Prime and has 3 or more receipts, deny access
      if (!isPrime && receipts.length >= 3) {
        throw Exception(
          "You have reached the limit (3 receipts). Subscribe to Prime to add more.",
        );
      }
    } catch (e) {
      throw Exception("Eligibility check failed: $e");
    }
  }

  /// Inserts a new receipt into the Supabase database for the current user.
  ///
  /// Requires a [ReceiptModel] object. The user's ID is automatically fetched.
  Future<void> addNewReceipt({required ReceiptModel receipt}) async {
    try {
      final user = await fetchUserById();
      if (user == null) throw Exception("User not found");

      await SupabaseConnect.supabase?.from('receipt').insert({
        ...receipt.mapForAddSupabase(),
        'app_user_id': user.userId,
      });
    } catch (e) {
      throw Exception("Failed to add receipt: $e");
    }
  }

  /// Retrieves all receipts for the current user from Supabase.
  ///
  /// Returns a list of [ReceiptModel] or an empty list if none found.
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
      throw Exception("Failed to get all receipts: $e");
    }
  }

  /// Updates a receipt with the given [receiptId] and new [updatedData].
  ///
  /// Returns the updated receipt as a list of [ReceiptModel] (usually 1 item).
  Future<List<ReceiptModel>> updateReceipt(
    Map<String, dynamic> updatedData,
    String receiptId,
  ) async {
    try {
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
    } catch (e) {
      throw Exception("Failed to upload receipt: $e");
    }
  }

  /// Deletes a receipt with the given [receiptId] from Supabase.
  ///
  /// Only deletes if the receipt belongs to the current user.
  Future<void> deleteReceipt(String receiptId) async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    try {
      final response = await SupabaseConnect.supabase!
          .from('receipt')
          .delete()
          .eq('receipt_id', receiptId)
          .eq('app_user_id', user.userId);

      return;
    } catch (e) {
      throw Exception("Delete failed: $e");
    }
  }

  /// Uploads a receipt image to Supabase Storage and returns its public URL.
  ///
  /// The image is stored under a path that includes the user's ID and a timestamp.
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

  /// Calculates the total amount spent in a specific [month] and [year].
  ///
  /// Filters receipts by the user's ID and `date` field range.
  Future<double> getMonthlyTotalAmount({
    required int year,
    required int month,
  }) async {
    try {
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
    } catch (e) {
      throw Exception("Failed to get monthly receipts: $e");
    }
  }

  /// Retrieves all receipts in a specific [month] and [year] for the current user.
  ///
  /// Filters results based on the `date` field.
  Future<List<ReceiptModel>> getMonthlyReceipts({
    required int year,
    required int month,
  }) async {
    try {
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
    } catch (e) {
      throw Exception("Failed to get monthly receipts: $e");
    }
  }
}
