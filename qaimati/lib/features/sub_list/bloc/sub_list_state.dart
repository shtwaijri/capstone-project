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

class ItemModel {
  String name;
  int quantity;
  bool isImportant;
  String createdBy;
  bool isChecked;

  ItemModel({
    required this.name,
    required this.quantity,
    this.isImportant = false,
    required this.createdBy,
    this.isChecked = false,
  });

  ItemModel copyWith({
    String? name,
    int? quantity,
    bool? isImportant,
    String? createdBy,
    bool? isChecked,
  }) {
    return ItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      isImportant: isImportant ?? this.isImportant,
      createdBy: createdBy ?? this.createdBy,
      isChecked: isChecked ?? this.isChecked,
    );
  }
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
