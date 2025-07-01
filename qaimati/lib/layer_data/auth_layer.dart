import 'dart:developer';

import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  //will be used later
  // bool isSignIn = false;
  // String? idUser;
  //bool isSignIn = false;
  String? idUser = "cf2eb3c1-0d12-46dd-973e-eceb15dc6695";
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
 //   idUser = prefs.getString('userId');
    return prefs.getString('userId');
  }

   //method to cplete user profile
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
   Future<void> getUser(String userId) async {
    try {
      log("📥 Fetching user from Supabase: AuthLayer");

      user = await SupabaseConnect.getUser(userId);
      log("end AuthLayer ");
    } catch (_) {
      rethrow;
    }
}
