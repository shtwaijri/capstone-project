part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class ValidateEmailEvent extends AuthEvent {
  final String email;

  ValidateEmailEvent({required this.email});
}

class SendOtpEvent extends AuthEvent {}

class VerifyOtpEvent extends AuthEvent {
  final String otp;

  VerifyOtpEvent(this.otp);
}

class OtpOnChangeEvent extends AuthEvent {
  final int index;
  final String value;

  OtpOnChangeEvent({required this.index, required this.value});
}
