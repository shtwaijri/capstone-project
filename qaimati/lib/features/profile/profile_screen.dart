// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/auth_screen.dart';

import 'package:qaimati/features/prime/prime_screen.dart';
import 'package:qaimati/features/profile/bloc/profile_bloc.dart';
import 'package:qaimati/features/profile/widgets/custom_alert_dialog.dart';
import 'package:qaimati/features/profile/widgets/custom_widget_setting.dart';
import 'package:qaimati/features/profile/widgets/profile_shimmer.dart';
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
    final iconSize = context.getWidth() * 0.06;

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
              }
            },
            child: Scaffold(
              appBar: AppBarWidget(
                title: tr('profileTitle'),
                showActions: false,
                showSearchBar: false,
                showBackButton: false,
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
                              textStyle: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: iconSize,

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
                              textStyle: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: iconSize,
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
                              textStyle: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: iconSize,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    //using provider.value to keep the same instance of profilebloc
                                    return BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: CustomAlertDialog(
                                        controller: nameController,
                                        title: tr("changeName"),
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
                              textStyle: StyleText.bold16(context),
                              color: StyleColor.green,
                              iconSize: iconSize,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: CustomAlertDialog(
                                        controller: emailController,
                                        title: tr("ChangeEmail"),

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
                              textStyle: StyleText.bold16(context),

                              color: StyleColor.green,
                              iconSize: iconSize,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => const PrimeScreen(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(100),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: context.getHeight() * 0.03),
                            //Logout
                            CustomWidgetSetting(
                              icon: Icons.exit_to_app,
                              text: tr('authLogout'),
                              textStyle: StyleText.bold16(context),

                              color: StyleColor.error,
                              iconSize: iconSize,
                              onTap: () async {
                                // Show the confirmation dialog before logout
                                logoutAlertDialog(
                                  context: context,
                                  onTab: () async {
                                    await Supabase.instance.client.auth
                                        .signOut();
                                    //reset the lang to english
                                    context.setLocale(const Locale('en', 'US'));
                                    //reset the theme mode to the default light
                                    ThemeController.themeNotifier.value =
                                        ThemeMode.light;

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
                    return const Center(child: ProfileShimmerEffect());
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
  final colorScheme = Theme.of(context).colorScheme;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,

      content: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.getWidth() * 0.01,
          vertical: context.getHeight() * 0.01,
        ),
        child: Text(
          tr('confirmLogout'),
          style: StyleText.bold16(context).copyWith(color: StyleColor.error),
        ),
      ),

      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            tr('commonCancel'),
            style: StyleText.bold16(
              context,
            ).copyWith(color: colorScheme.onSurface),
          ),
        ),
        TextButton(
          onPressed: onTab,
          child: Text(
            tr('authLogout'),
            style: StyleText.bold16(context).copyWith(color: StyleColor.error),
          ),
        ),
      ],
    ),
  );
}
