// ignore_for_file: must_be_immutable

part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthStateInit extends AuthState {}

final class LoadingSignUpState extends AuthState {}

final class SuccessState extends AuthState {}

final class ErrorState extends AuthState {
  final String msg;

  ErrorState({required this.msg});
}

final class OTPUpdatedState extends AuthState {
  List<String> digits;
  OTPUpdatedState({required this.digits});
}
