import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/features/expenses/receipt_data.dart';
import 'package:qaimati/firebase_options.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qaimati/utilities/helper/onesignal_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize(dotenv.env["appIDOneSignal"].toString());
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(false);

  //to ensure that the current user is saved
  await SupabaseConnect.init();
  log("session: ${Supabase.instance.client.auth.currentSession}");

  await EasyLocalization.ensureInitialized();
  GetIt.I.registerSingletonAsync<AuthLayer>(() async => AuthLayer());
  GetIt.I.registerSingletonAsync<AppDatatLayer>(() async => AppDatatLayer());

  GetIt.I.registerSingletonAsync<ReceiptData>(
    () async => ReceiptData()..loadDataFromSupabase(),
  );
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  GetIt.I.registerSingleton<bool>(
    seenOnboarding,
    instanceName: 'seenOnboarding',
  );
<<<<<<< HEAD
=======
  
 
>>>>>>> 62c8815b09b3707caa438ffe44fcaf93e3768612

  //  final User? currentUser = Supabase.instance.client.auth.currentUser;
  //   if (currentUser != null && currentUser.id != null) {
  //     OneSignal.login(currentUser.id);
  //     print("🎉 OneSignal: Logged in user ${currentUser.id!} on app start (already authenticated).");
  //   } else {
  //     print("⚠️ OneSignal: No active Supabase user session found at startup. Login to OneSignal will happen after user authenticates.");
  //   }
}
