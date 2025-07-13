// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/layer_data/receipt_data.dart';
import 'package:qaimati/features/intro/onboarding_info.dart';
import 'package:qaimati/repository/prime_service.dart';
import 'package:qaimati/firebase_options.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> setUp() async {
  // 1. Initialize Flutter binding and environment
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // 2. Register basic services
  GetIt.instance.registerLazySingleton<OnboardingInfo>(() => OnboardingInfo());

  // 3. Configure OneSignal
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(dotenv.env["appIDOneSignal"].toString());
  OneSignal.Notifications.requestPermission(false);

  // 4. Initialize Supabase
  await SupabaseConnect.init();

  // 5. Initialize localization
  await EasyLocalization.ensureInitialized();

  // 6. Register core services
  GetIt.I.registerSingleton<AuthLayer>(AuthLayer()); // Changed to synchronous
  GetIt.I.registerSingletonAsync<AppDatatLayer>(() async => AppDatatLayer());

  // 7. Load onboarding status
  final prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<bool>(
    prefs.getBool('seenOnboarding') ?? false,
    instanceName: 'seenOnboarding',
  );

  // 8. Register ReceiptData with lazy loading (without immediate data fetch)
  GetIt.I.registerLazySingleton<ReceiptData>(() => ReceiptData());

  // 9. Wait for all async services to initialize
  await GetIt.I.allReady();

  // 10. Check auth state and load data if logged in
  final supabase = Supabase.instance.client;
  if (supabase.auth.currentUser != null) {
    try {
      // Now safely load data when needed
      await GetIt.I<ReceiptData>().loadMonthlyDataFromSupabase(
        year: DateTime.now().year,
        month: DateTime.now().month,
      );

      await PrimeService.checkAndExpirePrimeStatus();
    } catch (e) {
      log('Error loading user data: $e');
      // Handle error appropriately
    }
  }
}

