import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'sub_list_event.dart';
part 'sub_list_state.dart';

class SubListBloc extends Bloc<SubListEvent, SubListState> {
  int number = 0;
  bool isItemImportant = false;
  String? currentExternalId;
  TextEditingController itemController = TextEditingController();

  List<ItemModel> items = [];

  SubListBloc() : super(SubListInitial()) {
    on<SubListEvent>((event, emit) async {});

    on<IncrementNumberEvent>(incrementNumberMethod);
    on<DecrementNumberEvent>(decrementNumberMethod);
    on<ChooseImportanceEvent>(chooseImportanceMethod);
    on<AddItemToListEvent>(addItemToListMethod);
    on<ToggleItemCheckedEvent>(toggleItemCheckedMethod);
    on<UpdateItemEvent>(updateItemMethod); // NEW
    on<DeleteItemEvent>(deleteItemMethod); // NEW
    on<LoadInitialItemDataEvent>(loadInitialItemDataMethod); // NEW
    on<ResetBlocStateEvent>(resetBlocStateMethod);

    emit(SubListLoadedState(items: items, currentNumber: number, currentIsItemImportant: isItemImportant));
  }

  void _emitLoadedState(Emitter<SubListState> emit) {
    emit(SubListLoadedState(
      items: List.from(items),
      currentNumber: number,
      currentIsItemImportant: isItemImportant,
    ));
  }

  FutureOr<void> incrementNumberMethod(
    IncrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    number++;
    _emitLoadedState(emit);
  }

  FutureOr<void> decrementNumberMethod(
    DecrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    if (number > 0) {
      number--;
    }
    _emitLoadedState(emit);
  }

  FutureOr<void> chooseImportanceMethod(
    ChooseImportanceEvent event,
    Emitter<SubListState> emit,
  ) {
    isItemImportant = event.isImportant;
    _emitLoadedState(emit);
  }

  FutureOr<void> addItemToListMethod(
    AddItemToListEvent event,
    Emitter<SubListState> emit,
  ) {
    final newItem = ItemModel(
      name: event.itemName,
      quantity: event.quantity,
      isImportant: event.isImportant,
      createdBy: event.createdBy,
    );
    items.add(newItem);

    // Reset fields after adding
    // number = 0;
    // isItemImportant = false;
    // itemController.clear();

    _emitLoadedState(emit);
  }

  FutureOr<void> toggleItemCheckedMethod(
    ToggleItemCheckedEvent event,
    Emitter<SubListState> emit,
  ) {
    if (event.index >= 0 && event.index < items.length) {
      items[event.index] = items[event.index].copyWith(isChecked: event.isChecked);
      _emitLoadedState(emit);
    }
  }

  // NEW: Update Item Method
  FutureOr<void> updateItemMethod(
    UpdateItemEvent event,
    Emitter<SubListState> emit,
  ) {
    if (event.index >= 0 && event.index < items.length) {
      items[event.index] = items[event.index].copyWith(
        name: event.newItemName,
        quantity: event.newQuantity,
        isImportant: event.newIsImportant,
      );
      // Reset fields after updating
      // number = 0;
      // isItemImportant = false;
      // itemController.clear();
      _emitLoadedState(emit);
    }
  }

  // NEW: Delete Item Method
  FutureOr<void> deleteItemMethod(
    DeleteItemEvent event,
    Emitter<SubListState> emit,
  ) {
    if (event.index >= 0 && event.index < items.length) {
      items.removeAt(event.index);
      // Reset fields after deleting
      // number = 0;
      // isItemImportant = false;
      // itemController.clear();
      _emitLoadedState(emit);
    }
  }

  // NEW: Load Initial Item Data for update/delete bottom sheet
  FutureOr<void> loadInitialItemDataMethod(
      LoadInitialItemDataEvent event, Emitter<SubListState> emit) {
    number = event.item.quantity;
    isItemImportant = event.item.isImportant;
    itemController.text = event.item.name;
    // Emit a state to update the UI (specifically the bottom sheet)
    emit(SubListLoadedState(
      items: List.from(items), // Keep current items
      currentNumber: number,
      currentIsItemImportant: isItemImportant,
    ));
  }

  Future<void> initializeOneSignalAndRequestPermissions() async {
    if (currentExternalId == null) {
      final newExternalId = 'user_${math.Random().nextInt(1000000)}';
      await OneSignal.login(newExternalId);
      await OneSignal.login(newExternalId);
      currentExternalId = newExternalId;
      log("Logged in with External ID: $currentExternalId");
    }
  }
FutureOr<void> resetBlocStateMethod(
  ResetBlocStateEvent event,
  Emitter<SubListState> emit,
) {
  number = 1;
  isItemImportant = false;
  itemController.clear();
  _emitLoadedState(emit); // مهم لإعادة بناء الواجهة
}
  @override
  Future<void> close() {
    itemController.dispose();
    return super.close();
  }
}