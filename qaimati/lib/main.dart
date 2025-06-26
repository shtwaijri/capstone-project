import 'package:flutter/material.dart';
 import 'package:easy_localization/easy_localization.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/style/theme/theme.dart';  
import 'package:qaimati/utilities/setup.dart';  
void main() async {
  await setUp(); 

  runApp( 
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR')],
      path: 'assets/translations', 
      fallbackLocale: Locale('en', 'US'),
      child: const MyApp(),  
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
      theme: CustomTheme.lightTheme,
      home: SubListScreen(), // أو الشاشة التي تريدين أن تكون البداية
    );
  }
}