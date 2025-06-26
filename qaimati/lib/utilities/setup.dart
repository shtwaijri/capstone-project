import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/firebase_options.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:firebase_core/firebase_core.dart';
 
Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // await SupabaseConnect.init();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // Initialize with your OneSignal App ID
  OneSignal.initialize(dotenv.env["appIDOneSignal"].toString(),);
  // Use this method to prompt for push notifications.
  // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
  OneSignal.Notifications.requestPermission(true);
  GetIt.I.registerSingleton<AuthLayer>(AuthLayer());
  GetIt.I.registerLazySingleton<AppDatatLayer>(() => AppDatatLayer());
}
