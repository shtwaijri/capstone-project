part of 'add_member_bloc.dart';

@immutable
sealed class AddMemberState {}

final class AddMemberInitial extends AddMemberState {}

final class AddMemberLoading extends AddMemberState {}

final class AddMemberSuccess extends AddMemberState {}

final class AddMemberFailure extends AddMemberState {
  final String error;

  AddMemberFailure(this.error);
}

class AddMemberLoadedState extends AddMemberState {
  final List<String> members;

  AddMemberLoadedState({required this.members});
}

class AddMemberErrorState extends AddMemberState {
  final String message;
  AddMemberErrorState(this.message);
}
