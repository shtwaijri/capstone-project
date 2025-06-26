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

 
 
//  class ItemModel {
//   final String name;
//   final int quantity;
//   final bool isImportant;
//   final String createdBy;
//   bool isChecked;  

//   ItemModel({
//     required this.name,
//     required this.quantity,
//     required this.isImportant,
//     required this.createdBy,
//     this.isChecked = false, 
//   });

//    ItemModel copyWith({
//     String? name,
//     int? quantity,
//     bool? isImportant,
//     String? createdBy,
//     bool? isChecked,
//   }) {
//     return ItemModel(
//       name: name ?? this.name,
//       quantity: quantity ?? this.quantity,
//       isImportant: isImportant ?? this.isImportant,
//       createdBy: createdBy ?? this.createdBy,
//       isChecked: isChecked ?? this.isChecked,
//     );
//   }
// }
class ItemModel {
  String name;
  int quantity;
  bool isImportant;
  String createdBy;
  bool isChecked; // 🔴 تأكد من إضافة هذا الحقل

  ItemModel({
    required this.name,
    required this.quantity,
    this.isImportant = false,
    required this.createdBy,
    this.isChecked = false, // 🔴 القيمة الافتراضية عند الإنشاء
  });

  // 🔴 تأكد من تحديث دالة copyWith
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


 class SubListLoadedState extends SubListState {
  final List<ItemModel> items;
  final int currentNumber; 
  final bool currentIsItemImportant;  

  SubListLoadedState({
    required this.items,
    required this.currentNumber,
    required this.currentIsItemImportant,
  });
}

