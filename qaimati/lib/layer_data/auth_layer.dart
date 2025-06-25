import 'dart:developer';

import 'package:qaimati/repository/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  //will be used later 
  // bool isSignIn = false;
  // String? idUser;
 

    Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      log("signUp AuthLayer starts");
      await SupabaseConnect.signUpByEmail(email: email, password: password);
      log("signUp AuthLayer end ss ");
    } catch (_) {
      log("signUp AuthLayer rethrow");
      rethrow;
    }
  }

  //login return AuthResponse from subabase
    Future<AuthResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      log("signUp AuthLayer starts");
      await SupabaseConnect.logInByEmail(email, password);
      log("signUp AuthLayer end ss ");
    } catch (_) {
      log("signUp AuthLayer rethrow");
      rethrow;
    }

    return null;
  }

    Future<void> updatePassword({required String password}) async {
    try {
      log("updatePassword AuthLayer starts");
      await SupabaseConnect.updatePassword(password);
      log("updatePassword AuthLayer end ss ");
    } catch (_) {
      log("updatePassword AuthLayer rethrow");
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
}
