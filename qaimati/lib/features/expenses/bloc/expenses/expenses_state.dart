part of 'expenses_bloc.dart';

@immutable
sealed class ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

final class SuccessState extends ExpensesState {
  final List<ReceiptModel> receipt;
  final DateTime displayedDate;
  SuccessState(this.receipt, this.displayedDate);
}

final class ErrorState extends ExpensesState {
  final String message;

  ErrorState(this.message);
}

final class LoadingState extends ExpensesState {}

final class IsPremiumiState extends ExpensesState {}

final class IsNotPremiumiState extends ExpensesState {
  final String message;

  IsNotPremiumiState([this.message = "receiptLimitReached"]);
}
