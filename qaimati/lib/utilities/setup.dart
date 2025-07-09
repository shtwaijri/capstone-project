// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/features/expenses/receipt_data.dart';
import 'package:qaimati/features/intro/onboarding_info.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  GetIt.instance.registerLazySingleton<OnboardingInfo>(() => OnboardingInfo());
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

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  GetIt.I.registerSingleton<bool>(
    seenOnboarding,
    instanceName: 'seenOnboarding',
  );

  GetIt.I.registerSingletonAsync<ReceiptData>(
    () async => ReceiptData()..loadAllDataFromSupabase(),
  );
  if (!GetIt.I.isRegistered<ReceiptData>()) {
    GetIt.I.registerSingletonAsync<ReceiptData>(
      () async => ReceiptData()
        ..loadMonthlyDataFromSupabase(
          year: DateTime.now().year,
          month: DateTime.now().month,
        ),
    );
  }
  // await PrimeService.checkAndExpirePrimeStatus();

  //  final User? currentUser = Supabase.instance.client.auth.currentUser;
  //   if (currentUser != null && currentUser.id != null) {
  //     OneSignal.login(currentUser.id);
  //     print("🎉 OneSignal: Logged in user ${currentUser.id!} on app start (already authenticated).");
  //   } else {
  //     print("⚠️ OneSignal: No active Supabase user session found at startup. Login to OneSignal will happen after user authenticates.");
  //   }
}
