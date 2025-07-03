import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/prime/payment_screen.dart';
import 'package:qaimati/features/profile/widgets/custom_alert_dialog.dart';
import 'package:qaimati/features/profile/widgets/custom_widget_setting.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/style/theme/theme_controller.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

bool isArabic = false;
bool isDarkMode = false;
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: tr('profileTitle'),

        showActions: false,
        showSearchBar: false,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.getWidth() * 0.05),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text("name", style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.01),
              Text("name@gmail.com", style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),
              Text(tr("settingsTitle"), style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: Icons.language,
                text: tr('settingsLanguage'),

                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
                showSwitch: true,
                switchValue: isArabic,

                onChanged: (value) {
                  setState(() {
                    isArabic = value;
                  });

                  //to change the lang
                  if (value) {
                    context.setLocale(const Locale('ar', 'AR'));
                  } else {
                    context.setLocale(const Locale('en', 'US'));
                  }
                },
              ),

              // SizedBox(height: context.getHeight() * 0.03),
              CustomWidgetSetting(
                icon: Icons.color_lens,
                text: tr('settingsColor'),
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.07,
                showSwitch: true,
                switchValue: Theme.of(context).brightness == Brightness.dark,

                onChanged: (value) {
                  setState(() {
                    ThemeController.toggleTheme(value);
                  });
                },
              ),
              // SizedBox(height: context.getHeight() * 0.03),
              // Icon(Icons.abc, color: Colors.green),
              Text(tr("accountTitle"), style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),

              // Row(
              //   children: [Icon(Icons.language), Text("name@Change app language")],
              // ),
              CustomWidgetSetting(
                icon: CupertinoIcons.person_fill,
                text: tr('accountName'),
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        controller: nameController,
                        title: "Change your name",
                        onConfirm: () {},
                      );
                    },
                  );
                },
              ),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: CupertinoIcons.mail_solid,
                text: tr('accountEmail'),
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        controller: emailController,
                        title: "Change your email",
                        onConfirm: () {},
                      );
                    },
                  );
                },
              ),

              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: CupertinoIcons.star_fill,
                text: tr('accountPremium'),
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  );
                },
              ),
              SizedBox(height: context.getHeight() * 0.03),
              CustomWidgetSetting(
                icon: Icons.exit_to_app,
                text: tr('authLogout'),

                style: StyleText.bold16(
                  context,
                ).copyWith(color: StyleColor.error),
                color: StyleColor.error,
                iconSize: context.getWidth() * 0.06,
                onTap: () {
                  () async {
                    await Supabase.instance.client.auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                      (route) => false,
                    );
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
