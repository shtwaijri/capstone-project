import 'dart:core';

import 'package:flutter/material.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/features/profile/widgets/custom_widget_setting.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Profile',
        showActions: false,
        showSearchBar: false,
      ),

      body: Padding(
        padding: EdgeInsetsGeometry.only(right: 20),
        // padding: EdgeInsets.symmetric(
        //   horizontal: context.getWidth() * 0.3,
        //   vertical: context.getHeight() * 0.03,
        // ),
        child: Column(
          children: [
            Text("name", style: StyleText.bold16(context)),
            Text("name@gmail.com"),
            Text("Setting", style: StyleText.bold16(context)),

            CustomWidgetSetting(
              icon: Icons.language,
              text: 'Change app language',
              style: StyleText.bold16(context),
            ),
            CustomWidgetSetting(
              icon: Icons.color_lens,
              text: 'Change app color',
              style: StyleText.bold16(context),
            ),
            Text("Account", style: StyleText.bold16(context)),

            // Row(
            //   children: [Icon(Icons.language), Text("name@Change app language")],
            // ),
            CustomWidgetSetting(
              icon: Icons.person,
              text: 'Change account name',
              style: StyleText.bold16(context),
            ),
            CustomWidgetSetting(
              icon: Icons.mail,
              text: 'Change account email',
              style: StyleText.bold12(context),
            ),
            CustomWidgetSetting(
              icon: Icons.star,
              text: 'Prime plus',
              style: StyleText.bold16(context),
            ),
          ],
        ),
      ),
    );
  }
}
