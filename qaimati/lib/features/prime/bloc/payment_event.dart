part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class ActivatePrimeEvent extends PaymentEvent {}

class RemainingPrimeDays extends PaymentEvent {}
