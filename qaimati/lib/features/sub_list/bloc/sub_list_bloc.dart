import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/models/item/item_model.dart';

part 'sub_list_event.dart';
part 'sub_list_state.dart';

class SubListBloc extends Bloc<SubListEvent, SubListState> {
  int number = 1;
  bool isItemImportant = false;
  String? currentExternalId;
  int selectedItems = 0;
  bool isItemsChecked = false;
  String? currentUserRole;
  String? listName;

  TextEditingController itemController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final authGetit = GetIt.I.get<AuthLayer>();
  final appGetit = GetIt.I.get<AppDatatLayer>();
  List<ItemModel> filteredItems = [];
  SubListBloc() : super(SubListInitial()) {
    on<SubListEvent>((event, emit) async {
      // _emitLoadedState(emit);
    });

    // on<IncrementNumberEvent>(incrementNumberMethod);
    // on<DecrementNumberEvent>(decrementNumberMethod);
    // on<ChooseImportanceEvent>(chooseImportanceMethod);
    on<AddItemToListEvent>(addItemToListMethod);
    on<ToggleItemCheckedEvent>(toggleItemCheckedMethod);
    on<LoadItemsEvent>(loadItemsMethods);
    on<IncrementNumberEvent>(_incrementNumber);
    on<DecrementNumberEvent>(_decrementNumber);
    //on<ChooseImportanceEvent>(chooseImportance);
    on<UpdateItemEvent>(updateItemMethod); // NEW
    on<DeleteItemEvent>(deleteItemMethod); // NEW
    on<ChooseImportanceEvent>(chooseImportance);
    // on<LoadInitialItemDataEvent>(loadInitialItemDataMethod); // NEW
    // on<ResetBlocStateEvent>(resetBlocStateMethod);

    //on<AddItemEvent>(addItemMethod);
  }

  void _filterAndEmitCurrentState(Emitter<SubListState> emit) {
    emit(
      SubListLoadedState(
        items: filteredItems,
        currentNumber: number,
        currentIsItemImportant: isItemImportant,
      ),
    );
  }

  FutureOr<void> toggleItemCheckedMethod(
    ToggleItemCheckedEvent event,
    Emitter<SubListState> emit,
  ) async {
    final itemIndexInAllItemsInGet = appGetit.items.indexWhere(
      (item) => item.itemId == event.itemId,
    );

    final itemIndexInAllItemsInFeilter = filteredItems.indexWhere(
      (item) => item.itemId == event.itemId,
    );

    //filteredItems
    if (itemIndexInAllItemsInGet != -1 && itemIndexInAllItemsInFeilter != -1) {
      // تحديث محلي
      final updatedItem = appGetit.items[itemIndexInAllItemsInGet].copyWith(
        status: event.isChecked,
      );
      appGetit.items[itemIndexInAllItemsInGet] = updatedItem;
      filteredItems[itemIndexInAllItemsInFeilter] = updatedItem;

      await appGetit.updateItemStatus(
        itemId: event.itemId!,
        status: event.isChecked,
      );

      for (var item in filteredItems) {
        if (item.status) {
          isItemsChecked = true;
          break;
        }
      }
      emit(UpdateScreentState());
    }
  }

  FutureOr<void> resetBlocStateMethod(
    ResetBlocStateEvent event,
    Emitter<SubListState> emit,
  ) {
    itemController.clear();
    number = 1;

    isItemImportant = false;
    isItemsChecked = false;
    emit(UpdateScreentState());
  }

  @override
  Future<void> close() {
    itemController.dispose();
    return super.close();
  }

  FutureOr<void> loadItemsMethods(
    LoadItemsEvent event,
    Emitter<SubListState> emit,
  ) async {
    await appGetit.getListsApp(userId: authGetit.idUser!);
    await authGetit.getUser(authGetit.idUser!);
    listName = listName = appGetit.lists
        .firstWhere((list) => list.listId == appGetit.listId)
        .name;
    for (var item in appGetit.items) {
      if (item.listId == appGetit.listId) {
        filteredItems.add(item);
        item.status ? isItemsChecked = true : "";
      }
    }
    currentUserRole = await appGetit.getUserRoleForCurrentList(
      userId: authGetit.idUser!,
      listId: appGetit.listId!,
    );
    authGetit.getUser;

    emit(LoadItemsState());
  }

  FutureOr<void> addItemToListMethod(
    AddItemToListEvent event,
    Emitter<SubListState> emit,
  ) async {
    log("--- SubListBloc: Handling AddItemToListEvent ---");
    log(
      "Item Name: ${event.itemName}, Quantity: ${event.quantity}, Important: ${event.isImportant}, Created By: ${event.createdBy}",
    );
    log("SubListBloc: Calling addNewItem in AppDatatLayer...");

    ItemModel? newItem = await appGetit.addNewItem(
      item: ItemModel(
        title: event.itemName,
        quantity: event.quantity,
        status: false,
        isCompleted: false,
        listId: appGetit.listId!,
        appUserId: authGetit.user!.userId,
        important: event.isImportant,
        createdBy: authGetit.user!.email,
      ),
    );

    if (newItem?.itemId != null) {
      log("bloc not feild");
      filteredItems.add(newItem!);
      appGetit.items.add(newItem);
    }
 itemController.clear();
    number = 1;

    isItemImportant = false;
    isItemsChecked = false;
    emit(UpdateScreentState());
     
  }

  void _incrementNumber(
    IncrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    number++;
    emit(
      SubListLoadedState(
        items: filteredItems,
        currentNumber: number,
        currentIsItemImportant: isItemImportant,
      ),
    );
  }

  void _decrementNumber(
    DecrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    if (number > 1) {
      number--;
      emit(
        SubListLoadedState(
          items: filteredItems,
          currentNumber: number,
          currentIsItemImportant: isItemImportant,
        ),
      );
    }
  }

  void chooseImportance(
    ChooseImportanceEvent event,
    Emitter<SubListState> emit,
  ) {
    isItemImportant = event.isImportant;
    emit(
      SubListLoadedState(
        items: filteredItems,
        currentNumber: number,
        currentIsItemImportant: isItemImportant,
      ),
    );
  }

  FutureOr<void> updateItemMethod(
    UpdateItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    final String newItemId = event.editedItem.itemId!;
    ItemModel editedItem = event.editedItem;
    editedItem.title = itemController.text;
    editedItem.quantity = number;
    editedItem.important = isItemImportant;

    try {
      final itemIndexInAppItems = appGetit.items.indexWhere(
        (item) => item.itemId == newItemId,
      );
      final itemIndexInFilteredItems = filteredItems.indexWhere(
        (item) => item.itemId == newItemId,
      );

      await appGetit.updateItem(item: editedItem);
      if (itemIndexInAppItems != -1) {
        appGetit.items[itemIndexInAppItems] = editedItem;

        if (itemIndexInFilteredItems != -1) {
          filteredItems[itemIndexInFilteredItems] = editedItem;
        }
      }
    } catch (e, stack) {
      log("❌ Error updating item object in SubListBloc: $e\n$stack");
    }

 itemController.clear();
    number = 1;

    isItemImportant = false;
    isItemsChecked = false;
    emit(UpdateScreentState());
    emit(UpdateScreentState());
  }

  FutureOr<void> deleteItemMethod(
    DeleteItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    ItemModel itemToDelete = event.item;

    try {
      final int itemIndexInFilter = filteredItems.indexWhere(
        (item) => item.itemId == itemToDelete.itemId,
      );

      final int itemIndexInAppItems = appGetit.items.indexWhere(
        (item) => item.itemId == itemToDelete.itemId,
      );

      await appGetit.deleteItem(item: itemToDelete);
      if (itemIndexInFilter != -1 && itemIndexInAppItems != -1) {
        filteredItems.removeAt(itemIndexInFilter);

        appGetit.items.removeAt(itemIndexInAppItems);

        emit(UpdateScreentState());
      } else {
        log(
          "Error: Item with ID ${itemToDelete.itemId} not found in one or both lists for deletion.",
        );
      }
    } catch (e, stack) {
      log("❌ Error deleting item in SubListBloc: $e\n$stack");
    }
  }
}
