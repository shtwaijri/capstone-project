// ignore_for_file: empty_catches

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/style/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  AppUserModel? user;

  Future<void> sendOtp({required String email}) async {
    try {
      await SupabaseConnect.sendOtp(email: email);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> verifyOtp({required String email, required String token}) async {
    try {
      await SupabaseConnect.verifyOtp(email: email, token: token);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> updateEmail({required String email}) async {
    try {
      await SupabaseConnect.updateEmail(email);
    } catch (_) {
      rethrow;
    }
  }

  //method to save user id in shared prefernce

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('userId', userId);
  }

  //retreive the saved userID using shared prefernce
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    return userId;
  }

  //method to get user id using the supabase
  String? getCurrentSessionId() {
    return Supabase.instance.client.auth.currentSession?.user.id;
  }

  //method to get user id using the supabase
  Future<AppUserModel?> getUserObj({required String userId}) {
    return SupabaseConnect.getUserFromAuth(userId);
  }

  //method to complete user profile
  static Future<void> completeUserProfile({
    required String userId,
    required String name,
    required String? email,
  }) async {
    try {
      await SupabaseConnect.upsertUserProfile(
        userId: userId,
        name: name,
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUser(String userId) async {
    try {
      user = await SupabaseConnect.getUser(userId);

      if (user != null && user!.userId.isNotEmpty) {
        OneSignal.login(user!.userId);
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> loadUserSettings(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('app_user')
          .select('language_code, theme_mode')
          .eq('auth_user_id', user.id)
          .single();

      final isDark = response['theme_mode'] == 'dark';
      final isArabic = response['language_code'] == 'ar';

      //ensure that the screen still exist
      if (!context.mounted) return;

      //change the lang and theme according to settings
      await context.setLocale(
        isArabic ? const Locale('ar', 'AR') : const Locale('en', 'US'),
      );

      ThemeController.toggleTheme(isDark);
    } catch (e) {}
  }
}
