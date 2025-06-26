import 'package:flutter/material.dart';
import 'package:qaimati/features/auth/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qaimati/features/loading/loading_screen.dart';
import 'package:qaimati/utilities/setup.dart';
import 'package:qaimati/widgets/custom_items_widget/custom_items.dart';

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
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LoadingScreen(),

    );
  }
}
