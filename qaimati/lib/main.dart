import 'package:flutter/material.dart';
import 'package:qaimati/features/auth/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qaimati/utilities/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUp();
  EasyLocalization(
    supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
    path: 'assets/translations', // <-- change the path of the translation files
    fallbackLocale: Locale('en', 'US'),
    child: MyApp(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LoginScreen(),
    );
  }
}
