part of 'expenses_bloc.dart';

@immutable
sealed class ExpensesState {}

final class ExpensesInitial extends ExpensesState {}

final class SuccessState extends ExpensesState {}

final class ErrorState extends ExpensesState {}

final class LoadingState extends ExpensesState {}
