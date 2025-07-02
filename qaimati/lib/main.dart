import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/Lists/lists_screen/lists_screen.dart';

import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/intro/onboarding.dart';
import 'package:qaimati/features/loading/loading_screen.dart';

import 'package:qaimati/style/theme/theme.dart';
import 'package:qaimati/utilities/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await setUp();
  //ensure all singletons (like AuthLayer) are initialized before running the app
  await GetIt.I.allReady();

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
      home: ListsScreen(), //AuthScreen(),
      //       SubListScreen(),
      // seenOnboarding ? LoadingScreen() : Onboarding(),
      // seenOnboarding ? AuthScreen() : Onboarding(),
      //       SubListScreen(),
      // seenOnboarding ? AuthScreen() : Onboarding(),
    );
  }
}
