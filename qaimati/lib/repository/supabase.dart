import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  static Future<User?> signUpByEmail({
    required String email,
    required String password,
  }) async {
    try {
      log("signUp start");
      final user = await supabase!.auth.signUp(
        password: password,
        email: email,
      );
      log("signUp end coorect SupabaseConnect");
      return user.user!;
    } on AuthException catch (e) {
      log("error AuthException  end coorect SupabaseConnect");
      final msg = e.message.toLowerCase();
      if (msg.contains('user already registered') ||
          msg.contains('already registered') ||
          msg.contains('duplicate')) {
        //to clarify the error
        throw Exception('This email is already registered.');
      }
    } catch (error) {
      log("error AuthException  end coorect SupabaseConnect cachs");

      throw FormatException("There is error with sign Up");
    }
    return null;
  }

  //method for signin

  static Future<AuthResponse> logInByEmail(
    String email,
    String password,
  ) async {
    //hold user data if the sign in went successfully with supabase method 'signInWithPassword'
    log("log in  start  SupabaseConnect");

    final response = await supabase!.auth.signInWithPassword(
      email: email,
      password: password,
    );
    //clarify the error if user=null
    log("signUp null SupabaseConnect");
    if (response.user == null) {
      throw Exception('Sign in error');
    }
    log("end  coorect SupabaseConnect");

    return response;
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
      throw Exception('Failed to sign out: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors during sign out.
      log('An unexpected error occurred during sign out: $e');
      throw Exception('An unexpected error occurred during sign out.');
    }
  }

  static Future<void> updatePassword(String newPassword) async {
    try {
      await supabase!.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      throw Exception("Failed to update email: $e");
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

  //add  here deleteUser method
}
