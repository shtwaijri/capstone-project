// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/intro/onboarding.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';

import 'package:qaimati/style/theme/theme.dart';
import 'package:qaimati/style/theme/theme_controller.dart';
import 'package:qaimati/utilities/setup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await setUp();
  await GetIt.I.allReady();

  final session = Supabase.instance.client.auth.currentSession;
  Locale startLocale = const Locale('en', 'US');
  bool isDark = false;

  if (session != null) {
    try {
      final response = await Supabase.instance.client
          .from('app_user')
          .select('language_code, theme_mode')
          .eq('auth_user_id', session.user.id)
          .single();

      isDark = response['theme_mode'] == 'dark';
      final isArabic = response['language_code'] == 'ar';

      startLocale = isArabic
          ? const Locale('ar', 'AR')
          : const Locale('en', 'US');
    } catch (e) {}
  }

  ThemeController.themeNotifier.value = isDark
      ? ThemeMode.dark
      : ThemeMode.light;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: startLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seenOnboarding = GetIt.I.get<bool>(instanceName: 'seenOnboarding');
    final session = Supabase.instance.client.auth.currentSession;

    Widget homeScreen;

    if (!seenOnboarding) {
      homeScreen = Onboarding();
    } else {
      if (session != null && session.user != null) {
        homeScreen = NavigationBarScreen();
      } else {
        homeScreen = AuthScreen();
      }
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: homeScreen,
        );
      },
    );
  }
}
