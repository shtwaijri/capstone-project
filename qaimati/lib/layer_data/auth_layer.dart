import 'dart:developer';

import 'package:qaimati/repository/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  //will be used later
  // bool isSignIn = false;
  // String? idUser;

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

  //login return AuthResponse from subabase
  Future<AuthResponse?> login({required String email}) async {
    try {
      log("signUp AuthLayer starts");
      await SupabaseConnect.sendOtp(email: email);
      log("signUp AuthLayer end ss ");
    } catch (_) {
      log("signUp AuthLayer rethrow");
      rethrow;
    }

    return null;
  }

  Future<void> updateEmail({required String email}) async {
    try {
      log("updateEmail AuthLayer starts");
      await SupabaseConnect.updateEmail(email);
      log("updateEmail AuthLayer end ss ");
    } catch (_) {
      log("updateEmail AuthLayer rethrow");
      rethrow;
    }
  }

  //method to save user id

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  //method to get user id
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
