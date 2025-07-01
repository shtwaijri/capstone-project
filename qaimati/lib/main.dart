import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';

import 'package:qaimati/features/auth/auth_screen.dart';

import 'package:qaimati/style/theme/theme.dart';
import 'package:qaimati/utilities/setup.dart';

import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/features/sub_list/tray.dart';
import 'package:qaimati/style/theme/theme.dart';  
import 'package:qaimati/utilities/setup.dart';  
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await setUp();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      // fallbackLocale: Locale('ar', 'AR'),
      // startLocale: Locale('ar', 'AR'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seenOnboarding = GetIt.I.get<bool>(instanceName: 'seenOnboarding');
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: CustomTheme.lightTheme,

      home:
//       SubListScreen(),
       seenOnboarding ? LoadingScreen() : Onboarding(),

      
    );
  }
}
