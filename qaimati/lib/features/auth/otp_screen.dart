// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/features/auth/bloc/auth_bloc.dart';
import 'package:qaimati/features/auth/complete_profile/complete_profile_screen.dart';
import 'package:qaimati/features/auth/widgets/custom_otp_field.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  ///list of 6 focus nodes to manage the focus for each otp feild
  //allow the smooth nav between them
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: '',
        showActions: true,
        showSearchBar: false,
        showBackButton: false,
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.03,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                tr("enterOTP"),
                style: StyleText.bold16(context),
                textAlign: TextAlign.center,
              ),
              StyleSize.sizeH40,

              //blocbuilder to listen for state and updates the otp field
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    //list to generate 6 of the customOTPFeild widget
                    children: List.generate(6, (index) {
                      return CustomOtpField(
                        //handle the current focus field
                        focusNode: _focusNodes[index],
                        //if the index<5 go forward to the next field
                        nextFocus: (index < 5) ? _focusNodes[index + 1] : null,
                        changed: (value) {
                          //sned the new OTP value to OtpOnChangeEvent
                          context.read<AuthBloc>().add(
                            OtpOnChangeEvent(index: index, value: value),
                          );
                        },
                      );
                    }),
                  );
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isCounting = state is ResendOtpCountState;
                  final secondsRemaining = isCounting
                      ? state.secondsRemaining
                      : 0;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: (isCounting || secondsRemaining > 0)
                            ? null
                            : () {
                                context.read<AuthBloc>().add(ResendOtpEvent());
                              },
                        child: Text(
                          tr('resendCode'),
                          style: TextStyle(
                            color: (isCounting || secondsRemaining > 0)
                                ? Colors.grey
                                : Colors.blue,
                          ),
                        ),
                      ),
                      if (isCounting)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            color: Colors.yellow,
                            child: Text(
                              tr(
                                'resendAvailableIn',
                                args: ['$secondsRemaining'],
                              ),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              //without rebuilding the widget, we use listner to handle the navigation
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  GetIt.I.get<AuthLayer>().getCurrentSessionId();

                  if (state is NewUserState || state is ExistingUserState) {
                    if (context.mounted) {
                      // await authLayer.loadUserSettings(context);
                    }

                    //if the user is new, we navigate him to complete profile
                    if (state is NewUserState) {
                      try {
                        final user = await fetchUserById();
                        OneSignal.login(user!.userId);
                        log("OneSignal log in in otp corect ");
                      } catch (e) {
                        log("OneSignal log in in otp $e");
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CompleteProfileScreen(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NavigationBarScreen(),
                        ),
                      );
                    }
                  }
                },
                child: ButtomWidget(
                  onTab: () {
                    final digits = context.read<AuthBloc>().otpDigits;
                    //ensure that the otp has all the values
                    if (digits.every((digit) => digit.isNotEmpty)) {
                      //join all the fields into one string
                      final otp = digits.join();
                      context.read<AuthBloc>().add(VerifyOtpEvent(otp));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(tr('incorrectedOTP'))),
                      );
                    }
                  },
                  textElevatedButton: tr('confirmCode'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
