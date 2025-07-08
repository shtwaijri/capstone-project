// ignore_for_file: must_be_immutable

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthStateInit extends AuthState {}

final class LoadingSignUpState extends AuthState {}

final class OtpSentState extends AuthState {}

final class SuccessState extends AuthState {} ////////

final class ErrorState extends AuthState {
  final String msg;

  ErrorState({required this.msg});
}

final class OTPUpdatedState extends AuthState {
  final List<String> digits;
  OTPUpdatedState({required this.digits});
}

final class NewUserState extends AuthState {}

final class ExistingUserState extends AuthState {}

class EmailValidState extends AuthState {}

final class ResendOtpCountState extends AuthState {
  final int secondsRemaining;

  ResendOtpCountState({required this.secondsRemaining});
}
