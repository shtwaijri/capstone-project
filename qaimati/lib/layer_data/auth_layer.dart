import 'dart:developer';

import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLayer {
  //will be used later
  //bool isSignIn = false;
  String? idUser = "cf2eb3c1-0d12-46dd-973e-eceb15dc6695";
  AppUserModel? user;
    Future<void> getUser(String userId) async {
    try {
      log("📥 Fetching user from Supabase: AuthLayer");

    user= await  SupabaseConnect.getUser(userId);
      log("end AuthLayer ");
    } catch (_) {
      rethrow;
    }
  }
}
