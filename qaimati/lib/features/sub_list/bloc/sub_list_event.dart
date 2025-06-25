part of 'sub_list_bloc.dart';

@immutable
sealed class SubListEvent {}

class IncrementNumberEvent extends SubListEvent {}

class DecrementNumberEvent extends SubListEvent {}

class ChooseImportanceEvent extends SubListEvent {
 final bool isImportant;

  ChooseImportanceEvent({required this.isImportant});
}
