import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/members/add_member_screen.dart';
import 'package:qaimati/features/members/notification_screen.dart';
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
      create: (context) => ProfileBloc()..add(LoadProfileSettingEvent()),
      child: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (previous, current) => current is ProfileLoaded,
        listener: (context, state) async {
          final s = state as ProfileLoaded;

          // تغيير اللغة بناءً على حالة البلوك
          await context.setLocale(
            s.isArabicState
                ? const Locale('ar', 'AR')
                : const Locale('en', 'US'),
          );

          // تغيير الثيم بناءً على حالة البلوك
          ThemeController.toggleTheme(s.isDarkModeState);
        },
        child: Scaffold(
          appBar: AppBarWidget(
            title: tr('profileTitle'),
            showActions: false,
            showSearchBar: false,
          ),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.getWidth() * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.name, style: StyleText.bold16(context)),
                        SizedBox(height: context.getHeight() * 0.01),
                        Text(state.email, style: StyleText.bold16(context)),
                        SizedBox(height: context.getHeight() * 0.03),
                        Text(
                          tr("settingsTitle"),
                          style: StyleText.bold16(context),
                        ),
                        SizedBox(height: context.getHeight() * 0.03),
                        CustomWidgetSetting(
                          icon: Icons.language,
                          text: tr('settingsLanguage'),
                          style: StyleText.bold16(context),
                          color: StyleColor.green,
                          iconSize: context.getWidth() * 0.06,
                          showSwitch: true,
                          switchValue: state.isArabicState,
                          onChanged: (value) async {
                            context.read<ProfileBloc>().add(
                              ClickChangeLangEvent(isArabic: value),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            await context.setLocale(
                              value
                                  ? const Locale('ar', 'AR')
                                  : const Locale('en', 'US'),
                            );
                          },
                        ),
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
                                return BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: CustomAlertDialog(
                                    controller: nameController,
                                    title: "Change your name",
                                    onConfirm: () {
                                      context.read<ProfileBloc>().add(
                                        UpdateNameEvent(nameController.text),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // ElevatedButton(
                        //   onPressed: () {
                        //     // هنا يتم الانتقال إلى صفحة إضافة الأعضاء
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => AddMemberPage(
                        //           listId: 'your-list-id-here',
                        //         ), // استخدم listId المناسب هنا
                        //       ),
                        //     );
                        //   },
                        //   child: Text('انتقل إلى صفحة إضافة الأعضاء'),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     // هنا يتم الانتقال إلى صفحة إضافة الأعضاء
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             NotificationsScreen(), // استخدم listId المناسب هنا
                        //       ),
                        //     );
                        //   },
                        //   child: Text('انتقل إلى صفحة إضافة الأعضاء'),
                        // ),
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
                              builder: (dialogContext) {
                                return BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: CustomAlertDialog(
                                    controller: emailController,
                                    title: "Change your email",
                                    onConfirm: () {
                                      context.read<ProfileBloc>().add(
                                        UpdateEmailEvent(emailController.text),
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
                        CustomWidgetSetting(
                          icon: CupertinoIcons.star_fill,
                          text: tr('accountPremium'),
                          style: StyleText.bold16(context),
                          color: StyleColor.green,
                          iconSize: context.getWidth() * 0.06,
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(),
                              ),
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
                          onTap: () async {
                            await Supabase.instance.client.auth.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => AuthScreen(),
                              ),
                              (route) => false,
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
      ),
    );
  }
}
