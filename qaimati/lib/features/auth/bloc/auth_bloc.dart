// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// ignore: unnecessary_import
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  //controllers for textfeild
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  //list to hold the OTP digits
  final List<String> _otpDigits = List.filled(6, '');

  //list to get the digits from the UI
  List<String> get otpDigits => List.unmodifiable(_otpDigits);

  //instance of AuthLayer
  final authGetit = GetIt.I.get<AuthLayer>();

  Timer? _resendOtpTimer;
  int _resendOtpSeconds = 0;

  AuthBloc() : super(AuthStateInit()) {
    on<ValidateEmailEvent>(_validateEmail);
    on<SendOtpEvent>(_sendOtpMethod);
    on<VerifyOtpEvent>(_verifyOtpMethod);
    on<OtpOnChangeEvent>((event, emit) {
      //to update the _otpDigits list with new digits
      _otpDigits[event.index] = event.value;
      //use list.from to save the digits as a copy
      emit(OTPUpdatedState(digits: List.from(_otpDigits)));
    });
    on<ResendOtpEvent>(_resendOtpMethod);
  }

  //method to send the OTP
  FutureOr<void> _sendOtpMethod(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      //show loading indicator
      emit(LoadingSignUpState());

      ///call sendOtp method from Authlayer
      //use trim for empty spaces
      await authGetit.sendOtp(email: emailController.text.trim());
      emit(OtpSentState());
    } catch (error) {
      //show the error messgae
      emit(ErrorState(msg: error.toString()));
    }
  }

  //method to verify OTP
  FutureOr<void> _verifyOtpMethod(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      //show loading indicator
      emit(LoadingSignUpState());

      ///call verifyOtp method from Authlayer
      await authGetit.verifyOtp(
        email: emailController.text.trim(),
        //token is the otp code
        token: event.otp.trim(),
      );
      final user = Supabase.instance.client.auth.currentSession?.user;
      //check if the user is logged in
      if (user == null) {
        emit(ErrorState(msg: 'User is not logged in'));
        return;
      }
      //check if the user exists
      //by using app_user table
      final response = await Supabase.instance.client
          .from('app_user')
          .select('name')
          .eq('auth_user_id', user.id)
          .maybeSingle();

      //check if the user is new(no profile in app_user table found)
      final isNewUser = response == null;

      //conditios if the user is new emit the new user state
      if (isNewUser) {
        emit(NewUserState());
      } else {
        //conditios if the user is exists emit the existing user state

        emit(ExistingUserState());
      }
    } catch (error) {
      emit(ErrorState(msg: error.toString()));
    }
  }

  FutureOr<void> _validateEmail(
    ValidateEmailEvent event,
    Emitter<AuthState> emit,
  ) {
    final email = event.email.trim();

    if (email.isEmpty) {
      emit(ErrorState(msg: tr("emailRequired")));
    }
    final regExp = RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$');
    if (!regExp.hasMatch(email)) {
      emit(ErrorState(msg: tr("email_invalid")));
    } else {
      emit(EmailValidState());
      add(SendOtpEvent());
    }
  }

  FutureOr<void> _resendOtpMethod(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (_resendOtpSeconds > 0) {
      return;
    }

    try {
      emit(LoadingSignUpState());

      await authGetit.sendOtp(email: emailController.text.trim());
      emit(OtpSentState());

      _startResendCountdown(emit);
    } catch (error) {
      emit(ErrorState(msg: error.toString()));
    }
  }

  void _startResendCountdown(Emitter<AuthState> emit) {
    _resendOtpSeconds = 60;
    _resendOtpTimer?.cancel();

    _resendOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendOtpSeconds--;
      print('Resend seconds remaining: $_resendOtpSeconds');

      if (_resendOtpSeconds <= 0) {
        timer.cancel();
        emit(OtpSentState());
      } else {
        emit(ResendOtpCountState(secondsRemaining: _resendOtpSeconds));
      }
    });
  }

  @override
  Future<void> close() {
    _resendOtpTimer?.cancel();
    return super.close();
  }
}
