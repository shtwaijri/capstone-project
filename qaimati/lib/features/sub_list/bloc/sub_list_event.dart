 
part of 'sub_list_bloc.dart';

@immutable
sealed class SubListEvent {}

 final class LoadSubListScreenData extends SubListEvent {}

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
  });
}

final class ToggleItemCheckedEvent extends SubListEvent {
  final String? itemId;
  final bool isChecked;
  ToggleItemCheckedEvent({required this.itemId, required this.isChecked});
}

final class IncrementNumberEvent extends SubListEvent {}

final class DecrementNumberEvent extends SubListEvent {}

final class UpdateItemEvent extends SubListEvent {
  final ItemModel editedItem;
  UpdateItemEvent({required this.editedItem});
}

final class DeleteItemEvent extends SubListEvent {
  final ItemModel item;
  DeleteItemEvent({required this.item});
}

final class ChooseImportanceEvent extends SubListEvent {
  final bool isImportant;
  ChooseImportanceEvent({required this.isImportant});
}

 final class MarkCheckedItemsAsCompletedEvent extends SubListEvent {}

 final class LoadCompletedItemsScreenData extends SubListEvent {}

// final class InitializeUpdateItemBottomSheetEvent extends SubListEvent {
//   final ItemModel item;

//   InitializeUpdateItemBottomSheetEvent({required this.item});
// }

final class CheckoutEvent  extends SubListEvent {}

 
 
 final class LoadCompletedItemsForListsEvent  extends SubListEvent {}
