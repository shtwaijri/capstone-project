part of 'auth.dart';

@immutable
sealed class AuthState {}
final class AuthStateInit extends AuthState {}

final class SignupInitial extends AuthState {}


final class LoadingSignUpState extends AuthState {}

final class SuccessState extends AuthState {}

final class ErrorState extends AuthState {
  final String msg;

  ErrorState({required this.msg});
}
