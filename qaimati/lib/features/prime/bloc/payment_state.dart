part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class SuccessState extends PaymentState {}

class ErrorState extends PaymentState {
  final String message;
  ErrorState(this.message);
}

class NotSubscribedState extends PaymentState {}

class SubscribedState extends PaymentState {}
