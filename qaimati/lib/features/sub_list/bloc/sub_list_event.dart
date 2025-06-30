part of 'sub_list_bloc.dart';

@immutable
class SubListEvent {}

class IncrementNumberEvent extends SubListEvent {}

class DecrementNumberEvent extends SubListEvent {}

class LoadItemsEvent extends SubListEvent {}

class ChooseImportanceEvent extends SubListEvent {
  final bool isImportant;

  ChooseImportanceEvent({required this.isImportant});
}

class AddItemToListEvent extends SubListEvent {
  final String itemName;
  final int quantity;
  final bool isImportant;
  final String createdBy;
  bool isChecked;

  AddItemToListEvent({
    required this.itemName,
    required this.quantity,
    required this.isImportant,
    required this.createdBy,
    this.isChecked = false,
  });
}

class UpdateItemEvent extends SubListEvent {
  final int index;
  final ItemModel editedItem;

  UpdateItemEvent( {required this.editedItem, required this.index});
}

class DeleteItemEvent extends SubListEvent {
  ItemModel item;
  final int index;

  DeleteItemEvent({required this.index, required this.item});
}

class LoadInitialItemDataEvent extends SubListEvent {
  final ItemModel item;
  LoadInitialItemDataEvent({required this.item});
}

class ResetBlocStateEvent extends SubListEvent {}

class AddItemEvent extends SubListEvent {
  final ItemModel newItem;

  AddItemEvent(this.newItem);
}

final class CompleteCheckedItemsEvent extends SubListEvent {}

class ToggleItemCheckedEvent extends SubListEvent {
  final int index;
  final bool isChecked;
  String? itemId;

  ToggleItemCheckedEvent({
    required this.index,
    required this.isChecked,
    this.itemId,
  });
}
