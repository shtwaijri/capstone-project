part of 'invite_bloc.dart';

@immutable
sealed class InviteState {}

class InviteInitialState extends InviteState {}

class InviteLoadingState extends InviteState {}

class InviteLoadedState extends InviteState {
  final List<Map<String, dynamic>> invitedLists;
  final List<InviteModel> notifications;

  InviteLoadedState({required this.invitedLists, required this.notifications});
}

class InviteErrorState extends InviteState {
  final String message;

  InviteErrorState(this.message);
}
