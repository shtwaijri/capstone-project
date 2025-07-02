part of 'expenses_bloc.dart';

@immutable
sealed class ExpensesEvent {}

class LoadingReceiptEvent extends ExpensesEvent {}
