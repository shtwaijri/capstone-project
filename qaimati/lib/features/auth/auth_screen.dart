// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/bloc/auth_bloc.dart';
import 'package:qaimati/features/auth/otp_screen.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<AuthBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: tr('Welcome to Qaimati'),
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
                  Text(
                    tr("Enter your email to create your account or login"),
                    style: StyleText.regular16(context),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: bloc.emailController,
                          decoration: InputDecoration(
                            labelText: tr('Email'),
                            labelStyle: StyleText.regular16(context),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${tr('authEmail')} ${tr("titlenotempty")}";
                            }
                            if (!value.contains('@')) {
                              return tr('authEmail') +
                                  " " +
                                  tr("authForgotPassword");
                            }
                            return null;
                          },
                          style: StyleText.regular16(context),
                        ),
                        const SizedBox(height: 20),
                        BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is SuccessState) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AuthBloc>(),
                                    child: OtpScreen(),
                                  ),
                                ),
                              );
                            } else if (state is ErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.msg)),
                              );
                            }
                          },
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color(0xFFB4DE95),
                                  ),
                                ),
                              ),
                            ),
                            child: ButtomWidget(
                              onTab: () {
                                if (_formKey.currentState?.validate() == true) {
                                  bloc.add(SendOtpEvent());
                                }
                              },
                              textElevatedButton: tr('onboardingNext'),
                            ),
                          ),
                        ),
                      ],
                    ),
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
