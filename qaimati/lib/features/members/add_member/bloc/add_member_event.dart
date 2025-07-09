part of 'add_member_bloc.dart';

@immutable
sealed class AddMemberEvent {}

class AddEmailEvent extends AddMemberEvent {
  final String email;

  AddEmailEvent(this.email);
}

class SendInviteEvent extends AddMemberEvent {
  final String email;
  final String listId;

  SendInviteEvent({required this.email, required this.listId});
}

class FetchMembersEvent extends AddMemberEvent {
  final String listId;

  FetchMembersEvent({required this.listId});
}

class DeleteMemberEvent extends AddMemberEvent {
  final String userId;
  final String listId;

  DeleteMemberEvent({required this.userId, required this.listId});
}
