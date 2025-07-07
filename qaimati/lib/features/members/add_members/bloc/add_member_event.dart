part of 'add_member_bloc.dart';

@immutable
sealed class AddMemberEvent {}

class onAddEmailEvent extends AddMemberEvent {
  final String email;

  onAddEmailEvent(this.email);
}

class SendInviteEvent extends AddMemberEvent {
  final String email;
  final String listId;

  SendInviteEvent({required this.email, required this.listId});
}
