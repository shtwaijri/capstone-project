part of 'invitations_bloc.dart';

@immutable
sealed class InvitationsState {}

class InviteInitialState extends InvitationsState {}

class InviteLoadingState extends InvitationsState {}

class InviteLoadedState extends InvitationsState {
  final List<Map<String, dynamic>> invitedLists;
  final List<InviteModel> notifications;

  InviteLoadedState({required this.invitedLists, required this.notifications});
}

class InviteErrorState extends InvitationsState {
  final String message;

  InviteErrorState(this.message);
}
