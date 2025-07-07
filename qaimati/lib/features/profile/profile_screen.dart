// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/prime/payment_screen.dart';
import 'package:qaimati/features/profile/bloc/profile_bloc.dart';
import 'package:qaimati/features/profile/widgets/custom_alert_dialog.dart';
import 'package:qaimati/features/profile/widgets/custom_widget_setting.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/style/theme/theme_controller.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    return BlocProvider(
      create: (_) => ProfileBloc(),
      //builder to access context
      child: Builder(
        builder: (context) {
          final bloc = context.read<ProfileBloc>();
          //initite LoadProfileEvent once the widget is built
          bloc.add(LoadProfileSettingEvent());

          return BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) async {
              if (state is ProfileLoadedState) {
                //change the lang based on the user
                await context.setLocale(
                  state.isArabicState
                      ? const Locale('ar', 'AR')
                      : const Locale('en', 'US'),
                );

                // change the theme by using theme controller
                ThemeController.toggleTheme(state.isDarkModeState);
              }
            },
            child: Scaffold(
              appBar: AppBarWidget(
                title: tr('profileTitle'),
                showActions: false,
                showSearchBar: false,
              ),
              body: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoadedState) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.getWidth() * 0.05,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //display the name
                            Text(state.name, style: StyleText.bold16(context)),
                            SizedBox(height: context.getHeight() * 0.01),

                            //display the email
                            Text(state.email, style: StyleText.bold16(context)),
                            SizedBox(height: context.getHeight() * 0.03),
                            Text(
                              tr("settingsTitle"),
                              style: StyleText.bold16(context),
                            ),
                            SizedBox(height: context.getHeight() * 0.03),
                            //change language
                            CustomWidgetSetting(
                              icon: Icons.language,
                              text: tr('settingsLanguage'),
                              style: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: context.getWidth() * 0.06,
                              showSwitch: true,
                              //the initial lang of the switch is depends on whether the app is arabic or not
                              switchValue: state.isArabicState,
                              onChanged: (value) async {
                                context.read<ProfileBloc>().add(
                                  ClickChangeLangEvent(isArabic: value),
                                );
                                //delay for the language changes
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );

                                //change the app lang based on the switch value
                                await context.setLocale(
                                  value
                                      ? const Locale('ar', 'AR')
                                      : const Locale('en', 'US'),
                                );
                              },
                            ),

                            //change theme
                            CustomWidgetSetting(
                              icon: Icons.color_lens,
                              text: tr('settingsColor'),
                              style: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: context.getWidth() * 0.07,
                              showSwitch: true,
                              switchValue: state.isDarkModeState,
                              onChanged: (value) {
                                context.read<ProfileBloc>().add(
                                  ClickChangeColorEvent(isDarkMode: value),
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    ThemeController.toggleTheme(value);
                                  },
                                );
                              },
                            ),
                            Text(
                              tr("accountTitle"),
                              style: StyleText.bold16(context),
                            ),
                            SizedBox(height: context.getHeight() * 0.03),
                            //change account name
                            CustomWidgetSetting(
                              icon: CupertinoIcons.person_fill,
                              text: tr('accountName'),
                              style: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: context.getWidth() * 0.06,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    //using provider.value to keep the same instance of profilebloc
                                    return BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: CustomAlertDialog(
                                        controller: nameController,
                                        title: "Change your name",
                                        onConfirm: () {
                                          context.read<ProfileBloc>().add(
                                            UpdateNameEvent(
                                              nameController.text,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(height: context.getHeight() * 0.03),
                            //change email
                            CustomWidgetSetting(
                              icon: CupertinoIcons.mail_solid,
                              text: tr('accountEmail'),
                              style: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: context.getWidth() * 0.06,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: CustomAlertDialog(
                                        controller: emailController,
                                        title: "Change your email",
                                        onConfirm: () {
                                          context.read<ProfileBloc>().add(
                                            UpdateEmailEvent(
                                              emailController.text,
                                            ),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(height: context.getHeight() * 0.03),
                            //prime plus
                            CustomWidgetSetting(
                              icon: CupertinoIcons.star_fill,
                              text: tr('accountPremium'),
                              style: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: context.getWidth() * 0.06,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: context.getHeight() * 0.03),
                            //Logout
                            CustomWidgetSetting(
                              icon: Icons.exit_to_app,
                              text: tr('authLogout'),
                              style: StyleText.bold16(
                                context,
                              ).copyWith(color: StyleColor.error),
                              color: StyleColor.error,
                              iconSize: context.getWidth() * 0.06,
                              onTap: () async {
                                // Show the confirmation dialog before logout
                                logoutAlertDialog(
                                  context: context,
                                  onTab: () async {
                                    await Supabase.instance.client.auth
                                        .signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => AuthScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

void logoutAlertDialog({
  required BuildContext context,
  required Function() onTab,
}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,

      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.getWidth() * 0.05,
          vertical: context.getHeight() * 0.03,
        ),
        child: Text(
          '?Are you sure you want to log out', // Text for confirmation
          style: const TextStyle(color: StyleColor.error),
        ),
      ),

      actions: <Widget>[
        // "Cancel" button to close the dialog
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: StyleColor.black)),
        ),
        // "Logout" button to confirm the logout action
        TextButton(
          onPressed: onTab, // Executes the logout functionality
          child: Text('Logout', style: TextStyle(color: StyleColor.error)),
        ),
      ],
    ),
  );
}
