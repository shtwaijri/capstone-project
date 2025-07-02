// lib/bloc/sub_list/sub_list_state.dart

part of 'sub_list_bloc.dart';

@immutable
sealed class SubListState {}

final class SubListInitial extends SubListState {}

final class SubListLoading extends SubListState {}

final class SubListLoadedState extends SubListState {
  final List<ItemModel> uncompletedItems;
  final List<ItemModel> completedItems;

  final int currentNumber;
  final bool currentIsItemImportant;
  final bool isItemsChecked;
  final String? currentUserRole;
  final String? listName;

  SubListLoadedState({
    required this.uncompletedItems,
    required this.completedItems,
    this.currentNumber = 1,
    this.currentIsItemImportant = false,
    this.isItemsChecked = false,
    this.currentUserRole,
    this.listName,
  });
}

final class CompletedItemsLoadedState extends SubListState {
  final Map<String, List<ItemModel>> completedItemsByListName;
  CompletedItemsLoadedState({required this.completedItemsByListName});
}

final class SubListError extends SubListState {
  final String message;
  SubListError({required this.message});
}

final class DeleteItemState extends SubListState {}

final class CheckoutState extends SubListState {}

final class MarkCheckedItemsAsCompletedState extends SubListState {}

 