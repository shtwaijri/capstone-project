part of 'sub_list_bloc.dart';

/// Base class for all events related to SubListBloc.

@immutable
sealed class SubListEvent {}

/// Event to trigger the initial loading of data for the SubList screen.
final class LoadSubListScreenData extends SubListEvent {}

/// Event to add a new item to the current list.
final class AddItemToListEvent extends SubListEvent {
  final String itemName;
  final int quantity;
  final bool isImportant;
  final String createdBy;

  AddItemToListEvent({
    required this.itemName,
    required this.quantity,
    required this.isImportant,
    required this.createdBy,

    /// Event to add a new item to the current list.
  });
}

/// Event to toggle the 'checked' status of a specific item.
final class ToggleItemCheckedEvent extends SubListEvent {
  final String? itemId;
  final bool isChecked;
  ToggleItemCheckedEvent({required this.itemId, required this.isChecked});
}

/// Event to increment a numerical value (item quantity).
final class IncrementNumberEvent extends SubListEvent {}

/// Event to decrement a numerical value ( item quantity).
final class DecrementNumberEvent extends SubListEvent {}

/// Event to decrement a numerical value (e.g., item quantity).
final class UpdateItemEvent extends SubListEvent {
  final ItemModel editedItem;
  UpdateItemEvent({required this.editedItem});
}

/// Event to delete an item from the list.
final class DeleteItemEvent extends SubListEvent {
  final ItemModel item;
  DeleteItemEvent({required this.item});
}

/// Event to set the 'importance' status for an item, often used before
/// adding or updating an item.
final class ChooseImportanceEvent extends SubListEvent {
  final bool isImportant;
  ChooseImportanceEvent({required this.isImportant});
}

/// Event to mark all currently checked items (status: true) as completed.
final class MarkCheckedItemsAsCompletedEvent extends SubListEvent {}

/// Event to trigger the loading of all items
final class LoadCompletedItemsScreenData extends SubListEvent {}

/// Event to initiate a 'checkout' process, typically to gather or prepare
/// items that have been checked before marking them as completed.
final class CheckoutEvent extends SubListEvent {}

/// Event to load completed items grouped by different lists,
/// potentially for an overview screen showing completed items across all lists.
final class LoadCompletedItemsForListsEvent extends SubListEvent {}
