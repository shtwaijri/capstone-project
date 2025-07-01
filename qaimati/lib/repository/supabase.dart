import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';

class SupabaseConnect {
  static SupabaseClient? supabase;
  static Future<void> init() async {
    log('start Supabase init');
    try {
      await Supabase.initialize(
        anonKey: dotenv.env['anonKey'].toString(),
        url: dotenv.env['url'].toString(),
      );

      supabase = Supabase.instance.client;

      log('end Supabase init');
      log('supabase client: $supabase');
    } catch (e) {
      log('Error in Supabase init: $e');
      throw FormatException('error in db initialization: $e');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////
  // static Future<void> sendOtp({required String email}) async {
  //   try {
  //     await supabase!.auth.signInWithOtp(email: email);
  //   } catch (e) {
  //     throw AuthException("Failed to send OTP: $e");
  //   }
  // }
  static Future<void> sendOtp({required String email}) async {
    try {
      if (supabase == null) {
        throw AuthException("Supabase is not initialized.");
      }

      await supabase!.auth.signInWithOtp(email: email);
    } catch (e) {
      throw AuthException("Failed to send OTP: $e");
    }
  }

  static Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await supabase!.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      if (response.user == null) {
        throw AuthException(
          "OTP verification failed. Invalid code or expired.",
        );
      }
    } catch (e) {
      throw AuthException("Failed to verify OTP: $e");
    }
  }

  /// Method to sign out the current user.
  /// It clears the user session and tokens locally.
  /// Throws an exception if an error occurs during the sign-out process.
  Future<void> signOut() async {
    try {
      await supabase!.auth.signOut();
      // Optional: You can add any additional logic here after successful sign out,
      // such as navigating the user to the login screen or clearing local data.
      log('User signed out successfully.');
    } on AuthException catch (e) {
      // Handle specific authentication errors during sign out (e.g., network issues).
      log('Error during sign out: ${e.message}');
      throw AuthException('Failed to sign out: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors during sign out.
      log('An unexpected error occurred during sign out: $e');
      throw AuthException('An unexpected error occurred during sign out.');
    }
  }

  static Future<void> updateEmail(String newEmail) async {
    try {
      log("updateEmail subabase start ");
      await supabase!.auth.updateUser(UserAttributes(email: newEmail));
      log("updateEmail subabase end  ");
    } catch (e) {
      log("updateEmail  error $e");

      throw Exception("Failed to update password: $e");
    }
  }

  //method to upser user info

  static Future<void> upsertUserProfile({
    required String userId,

    required String name,
    required String? email,
  }) async {
    try {
      await supabase!.from("app_user").upsert({
        'name': name,
        'email': email,
        'auth_user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to upsert user profile');
    }
  }

  //add  here deleteUser method
}
