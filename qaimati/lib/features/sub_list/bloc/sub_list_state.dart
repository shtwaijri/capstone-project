part of 'sub_list_bloc.dart';

@immutable
sealed class SubListState {}

final class SubListInitial extends SubListState {}


class ChangeNumberState extends SubListState {
  final int number;

  ChangeNumberState({required this.number});
}
 

class ChooseImportanceState extends SubListState {
  final bool isImportant;

  ChooseImportanceState({required this.isImportant});
}
