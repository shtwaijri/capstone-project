part of 'receipt_bloc.dart';

@immutable
sealed class ReceiptState {}

final class ReceiptInitial extends ReceiptState {}

final class SuccessState extends ReceiptState {
  final File image;
  final ReceiptApiModel receipt;
  SuccessState(this.image, this.receipt);
}

final class ErrorState extends ReceiptState {
  final String message;

  ErrorState(this.message);
}

final class LoadingState extends ReceiptState {}
