// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  final List<String> _otpDigits = List.filled(6, '');
  List<String> get otpDigits => List.unmodifiable(_otpDigits);

  final authGetit = GetIt.I.get<AuthLayer>();
  AuthBloc() : super(AuthStateInit()) {
    on<AuthEvent>((event, emit) {});
    on<SendOtpEvent>(_sendOtpMethod);
    on<VerifyOtpEvent>(_verifyOtpMethod);
    on<OtpOnChangeEvent>((event, emit) {
      _otpDigits[event.index] = event.value;
      emit(OTPUpdatedState(digits: List.from(_otpDigits)));
    });
  }

  //method to send the OTP

  FutureOr<void> _sendOtpMethod(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(LoadingSignUpState());
      await authGetit.sendOtp(email: emailController.text.trim());
      emit(OtpSentState());
    } catch (error) {
      log("sendOtp error: $error");
      emit(ErrorState(msg: error.toString()));
    }
  }

  //method to verify OTP
  FutureOr<void> _verifyOtpMethod(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(LoadingSignUpState());
      await authGetit.verifyOtp(
        email: emailController.text.trim(),
        token: event.token.trim(),
      );

      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        emit(ErrorState(msg: 'User is not logged in'));
        return;
      }

      final response = await Supabase.instance.client
          .from('app_user')
          .select('name')
          .eq('auth_user_id', user.id)
          .maybeSingle();
      final isNewUser = response == null;

      if (isNewUser) {
        emit(NewUserState());
      } else {
        emit(ExistingUserState());
      }
    } catch (error) {
      log("verifyOtp error: $error");
      emit(ErrorState(msg: error.toString()));
    }
  }
}
