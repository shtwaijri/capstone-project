// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/bloc/auth_bloc.dart';
import 'package:qaimati/features/auth/otp_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: tr('welcome'),
              showActions: true,
              showSearchBar: false,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.getWidth() * 0.05,
                vertical: context.getHeight() * 0.03,
              ),
              child: Column(
                children: [
                  Text(tr("enterEmail"), style: StyleText.regular16(context)),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      TextFormField(
                        //email controller from the authbloc
                        controller: bloc.emailController,
                        decoration: InputDecoration(
                          labelText: tr('emailHint'),
                          labelStyle: StyleText.regular16(context),
                          border: const OutlineInputBorder(),
                        ),
                        style: StyleText.regular16(context),
                      ),
                      //blocbuilder rebuild the UI after listeing  for the changes in bloc
                      //for error meassages
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String errorMsg = "";
                          if (state is ErrorState) {
                            errorMsg = state.msg;
                          }
                          //display the error msgs if it is not empty
                          return errorMsg.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(
                                    context.getWidth() * 0.02,
                                  ),
                                  child: Align(
                                    //get the current lang
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          errorMsg,
                                          style: StyleText.bold12(
                                            context,
                                          ).copyWith(color: StyleColor.error),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink();
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      //without rebuilding the widget, we use listner to handle the navigation
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is OtpSentState) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                //using provider.value to keep the same instance of authbloc
                                builder: (_) => BlocProvider.value(
                                  value: context.read<AuthBloc>(),
                                  child: OtpScreen(),
                                ),
                              ),
                            );
                          }
                        },
                        //custom elevated button
                        child: ButtomWidget(
                          onTab: () {
                            //validate the email before send the otp
                            final email = bloc.emailController.text.trim();

                            bloc.add(ValidateEmailEvent(email: email));
                          },
                          textElevatedButton: tr('onboardingNext'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
