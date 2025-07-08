part of 'invitations_bloc.dart';

@immutable
sealed class InvitationsEvent {}

class FetchInvitedListsEvent extends InvitationsEvent {}

class AcceptInviteEvent extends InvitationsEvent {
  final String inviteId;
  AcceptInviteEvent({required this.inviteId});
}

class RejectInviteEvent extends InvitationsEvent {
  final String inviteId;
  RejectInviteEvent({required this.inviteId});
}
