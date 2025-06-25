part of 'auth.dart';

 sealed class AuthEvent {}
//
class SignUpEvent extends AuthEvent {}

class LogInEvent extends AuthEvent {}