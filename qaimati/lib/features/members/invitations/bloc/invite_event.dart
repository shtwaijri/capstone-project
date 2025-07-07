part of 'invite_bloc.dart';

@immutable
sealed class InviteEvent {}

class FetchInvitedListsEvent extends InviteEvent {}

class GetNotificationsEvent extends InviteEvent {}

class AcceptInviteEvent extends InviteEvent {
  final String inviteId;

  AcceptInviteEvent({required this.inviteId});
}
