import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

class PrimeService {
  static Future<void> activatePrimeStatus() async {
    final user = await fetchUserById();
    if (user == null) throw Exception("User not found");

    await SupabaseConnect.supabase!
        .from('app_user')
        .update({
          'is_prime': true,
          'prime_start_date': DateTime.now().toIso8601String(),
        })
        .eq('user_id', user.userId);
  }

  static Future<void> checkAndExpirePrimeStatus() async {
    final user = await fetchUserById();
    if (user == null) return;

    final appUser = await SupabaseConnect.supabase!
        .from('app_user')
        .select('is_prime, prime_start_date')
        .eq('user_id', user.userId)
        .maybeSingle();

    if (appUser == null) return;

    final bool isPrime = appUser['is_prime'] ?? false;
    final String? startDateStr = appUser['prime_start_date'];

    if (isPrime && startDateStr != null) {
      final DateTime startDate = DateTime.parse(startDateStr);
      final DateTime now = DateTime.now();
      final bool expired = now.difference(startDate).inDays >= 30;

      if (expired) {
        await SupabaseConnect.supabase!
            .from('app_user')
            .update({'is_prime': false, 'prime_start_date': null})
            .eq('user_id', user.userId);
      }
    }
  }

  static Future<int?> getRemainingPrimeDays() async {
    final user = await fetchUserById();
    if (user == null) return null;

    final appUser = await SupabaseConnect.supabase!
        .from('app_user')
        .select('is_prime, prime_start_date')
        .eq('user_id', user.userId)
        .maybeSingle();

    if (appUser == null || !(appUser['is_prime'] ?? false)) return null;

    final String? startDateStr = appUser['prime_start_date'];
    if (startDateStr == null) return null;

    final DateTime startDate = DateTime.parse(startDateStr);
    final DateTime now = DateTime.now();

    final int daysPassed = now.difference(startDate).inDays;
    final int remainingDays = 30 - daysPassed;

    return remainingDays > 0 ? remainingDays : 0;
  }
}
