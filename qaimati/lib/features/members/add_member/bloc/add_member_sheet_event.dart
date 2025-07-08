part of 'add_member_sheet_bloc.dart';

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
