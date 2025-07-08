part of 'invite_bloc.dart';

@immutable
sealed class InviteEvent {}

class FetchInvitedListsEvent extends InviteEvent {}

class AcceptInviteEvent extends InviteEvent {
  final String inviteId;
  AcceptInviteEvent({required this.inviteId});
}

class RejectInviteEvent extends InviteEvent {
  final String inviteId;
  RejectInviteEvent({required this.inviteId});
}
