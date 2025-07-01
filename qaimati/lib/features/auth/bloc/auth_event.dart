part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SendOtpEvent extends AuthEvent {}

class VerifyOtpEvent extends AuthEvent {
  final String token;

  VerifyOtpEvent(this.token);
}

class OtpOnChangeEvent extends AuthEvent {
  final int index;
  final String value;

  OtpOnChangeEvent({required this.index, required this.value});
}
