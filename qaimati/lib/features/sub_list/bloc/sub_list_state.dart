// lib/bloc/sub_list/sub_list_state.dart
/// Base class for all states emitted by the SubListBloc.
part of 'sub_list_bloc.dart';

@immutable
sealed class SubListState {}

/// Initial state of the SubListBloc, typically emitted right after creation.

final class SubListInitial extends SubListState {}

/// State indicating that the SubListBloc is currently performing a long-running
/// operation,fetching data from a database.
final class SubListLoading extends SubListState {}

/// State representing the successful loading of data for the main SubList screen.
/// It contains all the necessary data to render the UI.
final class SubListLoadedState extends SubListState {
  final List<ItemModel> uncompletedItems;

  final int currentNumber;
  final bool currentIsItemImportant;
  final bool isItemsChecked;
  final String? currentUserRole;
  final String? listName;

  SubListLoadedState({
    required this.uncompletedItems,
    this.currentNumber = 1,
    this.currentIsItemImportant = false,
    this.isItemsChecked = false,
    this.currentUserRole,
    this.listName,
  });
}

/// State representing the successful loading of completed items, grouped by list name.
final class CompletedItemsLoadedState extends SubListState {
  final Map<String, List<ItemModel>> completedItemsByListName;
  CompletedItemsLoadedState({required this.completedItemsByListName});
}

/// State indicating that an error has occurred within the SubListBloc.
final class SubListError extends SubListState {
  final String message;
  SubListError({required this.message});
}

///State indicating that an item deletion operation has been performed.
/// This state  used to trigger a UI refresh or show a confirmation.
final class DeleteItemState extends SubListState {}

/// State indicating that a checkout process will start.
final class CheckoutState extends SubListState {}

/// State indicating that selected checked items have been successfully marked as completed.
final class MarkCheckedItemsAsCompletedState extends SubListState {}
 