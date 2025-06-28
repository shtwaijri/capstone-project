part of 'sub_list_bloc.dart';

@immutable
class SubListEvent {}

class IncrementNumberEvent extends SubListEvent {}

class DecrementNumberEvent extends SubListEvent {}

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

class ToggleItemCheckedEvent extends SubListEvent {
  final int index;
  final bool isChecked;

  ToggleItemCheckedEvent({required this.index, required this.isChecked});
}

class UpdateItemEvent extends SubListEvent {
  final int index;  
  final String newItemName;
  final int newQuantity;
  final bool newIsImportant;

  UpdateItemEvent({
    required this.index,
    required this.newItemName,
    required this.newQuantity,
    required this.newIsImportant,
  });
}

class DeleteItemEvent extends SubListEvent {
  final int index;

  DeleteItemEvent({required this.index});
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
