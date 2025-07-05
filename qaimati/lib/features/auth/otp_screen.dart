import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/auth/bloc/auth_bloc.dart';
import 'package:qaimati/features/auth/complete_profile/complete_profile_screen.dart';
import 'package:qaimati/features/auth/widgets/custom_otp_field.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
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
    //load user theme and lang
    final authLayer = GetIt.I.get<AuthLayer>();
    authLayer.loadUserSettings(context);
    return Scaffold(
      appBar: AppBarWidget(title: '', showActions: true, showSearchBar: false),

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

              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              //without rebuilding the widget, we use listner to handle the navigation
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  //to ensure if the user logged in
                  final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

                  //if the user is new, we navigate him to complete profile
                  if (state is NewUserState) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CompleteProfileScreen(),
                      ),
                    );
                  } else if (state is ExistingUserState) {
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User is not logged in')),
                      );
                      return;
                    }
                    try {
                      await authLayer.loadUserSettings(context);
                      //ensure that the screen is exists
                      if (!context.mounted) return;
                      //push to the navbarscreen after:
                      //1-checking if the user verified successfully
                      //2-load the theme and lang before navigate
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const NavigationBarScreen(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("An error occurred, please try again."),
                        ),
                      );
                    }
                  } else if (state is SuccessState) {
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User is not logged in')),
                      );
                      return;
                    }
                  } else if (state is ErrorState) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.msg)));
                  }
                },

                child: ButtomWidget(
                  onTab: () {
                    if (_formKey.currentState!.validate()) {
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
