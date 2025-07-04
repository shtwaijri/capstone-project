import 'dart:developer';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  //will be used later
  // bool isSignIn = false;
  // String? idUser;
  //bool isSignIn = false;

  //String? idUser = "cf2eb3c1-0d12-46dd-973e-eceb15dc6695";
  AppUserModel? user;

  AuthLayer() {
    //getUser(idUser!);
  }
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
      log("updateEmail AuthLayer starts");
      await SupabaseConnect.updateEmail(email);
      log("updateEmail AuthLayer end ss ");
    } catch (_) {
      log("updateEmail AuthLayer rethrow");
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
      log("📥 Fetching user from Supabase: AuthLayer");

      user = await SupabaseConnect.getUser(userId);

      // ⭐️⭐️⭐️ أضف هذا هنا ⭐️⭐️⭐️
      if (user != null && user!.userId.isNotEmpty) {
        OneSignal.login(user!.userId);
        print(
          "🎉 OneSignal: Logged in user ${user!.userId} after fetching user data.",
        );
      } else {
        print(
          "⚠️ OneSignal: User data or ID is null, cannot log in to OneSignal.",
        );
      }
      log("end AuthLayer ");
    } catch (_) {
      rethrow;
    }
  }
}
