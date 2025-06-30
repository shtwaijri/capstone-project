part of 'sub_list_bloc.dart';

@immutable
sealed class SubListState {}

final class SubListInitial extends SubListState {}

final class ChangeNumberState extends SubListState {
  final int number;
  ChangeNumberState({required this.number});
}

final class ChooseImportanceState extends SubListState {
  final bool isImportant;
  ChooseImportanceState({required this.isImportant});
}

final class SubListLoadedState extends SubListState {
  final List<ItemModel> items;
  final int currentNumber;
  final bool currentIsItemImportant;

  SubListLoadedState({
    required this.items,
    required this.currentNumber,
    required this.currentIsItemImportant,
  });

  SubListLoadedState copyWith({
    List<ItemModel>? items,
    int? currentNumber,
    bool? currentIsItemImportant,
    int? selectedItemsCount,
  }) {
    return SubListLoadedState(
      items: items ?? this.items,
      currentNumber: currentNumber ?? this.currentNumber,
      currentIsItemImportant:
          currentIsItemImportant ?? this.currentIsItemImportant,
    );
  }
}

final class SubListContentState extends SubListState {
  final List<ItemModel> items;
  final List<ItemModel> completedItems;
  final int number;
  final bool isItemImportant;

  SubListContentState({
    required this.items,
    required this.completedItems,
    required this.number,
    required this.isItemImportant,
  });
}

final class ItemsDisplayState extends SubListState {
  final List<ItemModel> items;
  final int currentNumber;
  final bool currentIsItemImportant;
  final bool isAnyItemChecked; // ⭐️ لـ bottomNavigationBar
  final String? currentUserRole; // ⭐️ لصلاحيات الزر

  ItemsDisplayState({
    required this.items,
    required this.currentNumber,
    required this.currentIsItemImportant,
    required this.isAnyItemChecked, // إضافة هذه
    this.currentUserRole, // إضافة هذه
  });

  ItemsDisplayState copyWith({
    List<ItemModel>? items,
    int? currentNumber,
    bool? currentIsItemImportant,
    bool? isAnyItemChecked,
    String? currentUserRole,
  }) {
    return ItemsDisplayState(
      items: items ?? this.items,
      currentNumber: currentNumber ?? this.currentNumber,
      currentIsItemImportant:
          currentIsItemImportant ?? this.currentIsItemImportant,
      isAnyItemChecked: isAnyItemChecked ?? this.isAnyItemChecked,
      currentUserRole: currentUserRole ?? this.currentUserRole,
    );
  }
}

final class UpdateScreentState extends SubListState {}

class LoadItemsState extends SubListState {}

final class SubListLoadingState extends SubListState {}

final class SubListErrorState extends SubListState {
  final String message;
  SubListErrorState(this.message);
}
