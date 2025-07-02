// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/auth/bloc/auth_bloc.dart';
import 'package:qaimati/features/auth/complete_profile/complete_profile_screen.dart';
import 'package:qaimati/features/auth/widgets/custom_otp_field.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width * 0.05;
    final verticalPadding = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      appBar: AppBarWidget(title: '', showActions: true, showSearchBar: false),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Enter the OTP code that it sent to your email",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return CustomOtpField(
                        focusNode: _focusNodes[index],
                        nextFocus: index < 5 ? _focusNodes[index + 1] : null,
                        changed: (value) {
                          context.read<AuthBloc>().add(
                            OtpOnChangeEvent(index: index, value: value),
                          );
                        },
                      );
                    }),
                  );
                },
              ),

              const SizedBox(height: 100),

              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is SuccessState) {
                    final userId = GetIt.I.get<AuthLayer>().getCurrentUserId();

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User is not logged in')),
                      );
                      return;
                    }
                    //to save the current user
                    await GetIt.I.get<AuthLayer>().saveUserId(userId);

                    try {
                      final response = await Supabase.instance.client
                          .from('app_user')
                          .select('name')
                          .eq('user_id', userId)
                          .maybeSingle();

                      final isNewUser =
                          response == null ||
                          response['full_name'] == null ||
                          response['full_name'].toString().isEmpty;

                      if (isNewUser) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompleteProfileScreen(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NavigationBarScreen(),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error : $e')));
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

                      if (digits.every((digit) => digit.isNotEmpty)) {
                        final token = digits.join();
                        context.read<AuthBloc>().add(VerifyOtpEvent(token));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Incorrected Code')),
                        );
                      }
                    }
                  },
                  textElevatedButton: 'Done',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
