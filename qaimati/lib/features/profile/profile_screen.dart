import 'dart:core';

import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/features/profile/widgets/custom_widget_setting.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

bool isArabic = false;

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Profile',
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
              SizedBox(height: context.getHeight() * 0.03),
              Text("name@gmail.com", style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),
              Text("Setting", style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: Icons.language,
                text: 'Change app language',
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
                showSwitch: true,
                switchValue: isArabic,

                onChanged: (value) {
                  setState(() {
                    isArabic = value;
                  });
                },
              ),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: Icons.color_lens,
                text: 'Change app color',
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
              ),
              SizedBox(height: context.getHeight() * 0.03),
              // Icon(Icons.abc, color: Colors.green),
              Text("Account", style: StyleText.bold16(context)),
              SizedBox(height: context.getHeight() * 0.03),

              // Row(
              //   children: [Icon(Icons.language), Text("name@Change app language")],
              // ),
              CustomWidgetSetting(
                icon: Icons.person,
                text: 'Change account name',
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
              ),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: Icons.mail,
                text: 'Change account email',
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
              ),
              SizedBox(height: context.getHeight() * 0.03),

              CustomWidgetSetting(
                icon: Icons.star,
                text: 'Prime plus',
                style: StyleText.bold16(context),
                color: StyleColor.green,
                iconSize: context.getWidth() * 0.06,
              ),
              SizedBox(height: context.getHeight() * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
