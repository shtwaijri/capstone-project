part of 'add_list_bloc.dart';

@immutable
sealed class AddListEvent {}

class LoadListsEvent extends AddListEvent {}

class LoadMemberListsEvent extends AddListEvent {}

class CreateListEvent extends AddListEvent {
  final String name;
  final int color;
  final DateTime createdAt;

  CreateListEvent({
    required this.name,
    required this.color,
    required this.createdAt,
  });
}

class UpdateListEvent extends AddListEvent {
  final ListModel list;
  UpdateListEvent(this.list);
}

class DeleteListEvent extends AddListEvent {
  final String listId;

  DeleteListEvent(this.listId);
}
