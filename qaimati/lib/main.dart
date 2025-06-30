import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:easy_localization/easy_localization.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/features/sub_list/tray.dart';
import 'package:qaimati/style/theme/theme.dart';  
import 'package:qaimati/utilities/setup.dart';  
import 'package:qaimati/features/auth/login_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qaimati/features/intro/bloc/onboarding_bloc.dart';
import 'package:qaimati/features/intro/onboarding.dart';
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
      home: BlocProvider(
      create: (_) => OnboardingBloc(totalPages: 3),
      child: SubListScreen(),
      ),
      //LoadingScreen(),

      theme: CustomTheme.lightTheme,
       
      
    );
  }
}