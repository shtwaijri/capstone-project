import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart'; // تأكد من استيراد ListModel

part 'sub_list_event.dart';
part 'sub_list_state.dart';

class SubListBloc extends Bloc<SubListEvent, SubListState> {
  int number = 1;
  bool isItemImportant = false;
  bool isItemsChecked = false;
  String? currentUserRole;
  String? listName;
  // String? idUser;
  AppUserModel? user;
  List<ItemModel> checkedItemsToComplete = [];
  TextEditingController itemController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final authGetit = GetIt.I.get<AuthLayer>();
  final appGetit = GetIt.I.get<AppDatatLayer>();

  Map<String, List<ItemModel>> completedItemsMap = {};
  StreamSubscription<List<ItemModel>>? _itemsSubscription;
  StreamSubscription<List<ListModel>>? _listsSubscription;

  SubListBloc() : super(SubListInitial()) {
    //initializeUserAndStreams();
    on<LoadSubListScreenData>((event, emit) async {
      await initializeUserAndStreams();

      await _loadInitialScreenData(emit);
      _updateSubListState();
    });
    on<AddItemToListEvent>(addItemToListMethod);
    on<CheckoutEvent>(checkoutMethod);
    on<ToggleItemCheckedEvent>(toggleItemCheckedMethod);
    on<IncrementNumberEvent>(_incrementNumber);
    on<DecrementNumberEvent>(_decrementNumber);
    on<UpdateItemEvent>(updateItemMethod);
    on<DeleteItemEvent>(deleteItemMethod);
    on<ChooseImportanceEvent>(chooseImportance);
    on<MarkCheckedItemsAsCompletedEvent>(markCheckedItemsAsCompletedMethod);
    on<LoadCompletedItemsScreenData>(onLoadCompletedItemsScreenData);
  }

  void _updateSubListState() {
    if (appGetit.listId == null) {
      log("SubListBloc: _currentListId is null, cannot update item state.");
      emit(SubListError(message: "No list selected."));
      return;
    }
    final uncompletedItems = appGetit.uncompletedItemsForCurrentList;
    final completedItems = appGetit.completedAndTrueStatusItemsForCurrentList;
    isItemsChecked = uncompletedItems.any((item) => item.status);

    emit(
      SubListLoadedState(
        uncompletedItems: uncompletedItems,
        completedItems: completedItems,
        currentNumber: number,
        currentIsItemImportant: isItemImportant,
        isItemsChecked: isItemsChecked,
        currentUserRole: currentUserRole,
        listName: listName,
      ),
    );
  }

  Future<void> _loadInitialScreenData(Emitter<SubListState> emit) async {
    emit(SubListLoading());
    try {
      // user= await  fetchUser();
      //idUser=await fetchUserId();
      // await authGetit.getUser(user!.userId);

      if (appGetit.listId != null) {
        try {
          listName = appGetit.lists
              .firstWhere((list) => list.listId == appGetit.listId)
              .name;
          //retrun latter
        } catch (e) {
          log(
            "SubListBloc: Could not find list name for ${appGetit.listId}: $e",
          );
          listName = "List".tr();
        }

        currentUserRole = await appGetit.getUserRoleForCurrentList(
          userId: user!.userId,
          listId: appGetit.listId!,
        );

        try {
          completedItemsMap = appGetit.allCompletedItemsByListName;

          log(
            "SubListBloc: Loaded completed items map for CompletedScreen. Map size: ${completedItemsMap.length}",
          );

          emit(
            CompletedItemsLoadedState(
              completedItemsByListName: completedItemsMap,
            ),
          );
        } catch (e, stack) {
          log(
            "❌ SubListBloc: Error in onLoadCompletedItemsScreenData: $e\n$stack",
          );
          emit(
            SubListError(
              message: "Failed to load completed items for screen: $e",
            ),
          );
        }
      }
    } catch (e, stack) {
      log("❌ SubListBloc: Error during initial screen data load: $e\n$stack");
      emit(SubListError(message: "Failed to load initial data: $e"));
    }
  }

  // @override
  // Future<void> close() {
  //   itemController.dispose();
  //   _itemsSubscription?.cancel();
  //   _listsSubscription?.cancel();
  //   log("SubListBloc: Streams cancelled and disposed.");
  //   return super.close();
  // }

  FutureOr<void> toggleItemCheckedMethod(
    ToggleItemCheckedEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      await appGetit.updateItemStatus(
        itemId: event.itemId!,
        status: event.isChecked,
      );
      log("SubListBloc: Item status updated successfully via AppDatatLayer.");
    } catch (e, stack) {
      log("❌ SubListBloc: Error toggling item status: $e\n$stack");
    }
    resetValues();
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
        appUserId: user!.userId,
        important: event.isImportant,
        createdBy: user!.email,
        createdAt: DateTime.now(),
      ),
    );

    if (newItem?.itemId != null) {
      log("bloc: New item added successfully with ID: ${newItem!.itemId}");
      try {
        final String currentListName = appGetit.lists
            .firstWhere((list) => list.listId == appGetit.listId)
            .name;

        final String notificationTitle =
            "${"newitemadded!".tr()} ${event.itemName}";
        final String notificationMessage =
            "${"item added by".tr()}  ${user!.email}  ${"inlist:".tr()}+ '$currentListName'.";

        log(
          "SubListBloc: Calling notifyUsersInList in AppDatatLayer for list ${appGetit.listId}",
        );
        await AppDatatLayer.notifyUsersInList(
          appGetit.listId!,
          notificationTitle,
          notificationMessage,
          user!.userId,
        );
        log("SubListBloc: Notification process initiated successfully.");
      } catch (e, stack) {
        log("❌ SubListBloc: Error during notification process: $e\n$stack");
      }
    } else {
      log("bloc: Failed to add new item. newItem.itemId is null.");
    }
    resetValues();
  }

  void _incrementNumber(
    IncrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    number++;
    _updateSubListState();
  }

  void _decrementNumber(
    DecrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    if (number > 1) {
      number--;
      _updateSubListState();
    }
  }

  void chooseImportance(
    ChooseImportanceEvent event,
    Emitter<SubListState> emit,
  ) {
    isItemImportant = event.isImportant;
    _updateSubListState();
  }

  FutureOr<void> updateItemMethod(
    UpdateItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    ItemModel editedItem = event.editedItem.copyWith(
      title: itemController.text,
      quantity: number,
      important: isItemImportant,
    );

    try {
      await appGetit.updateItem(item: editedItem);
      log("SubListBloc: Item updated successfully via AppDatatLayer.");

      if (appGetit.listId != null) {
        final String currentListName = appGetit.lists
            .firstWhere((list) => list.listId == appGetit.listId)
            .name;

        final String notificationTitle =
            "${"itemupdated!".tr()}  ${editedItem.title}";
        final String notificationMessage =
            "${"itemupdatedby".tr()} ${user!.email}${"inlist:".tr()}+ '$currentListName'.";

        await AppDatatLayer.notifyUsersInList(
          appGetit.listId!,
          notificationTitle,
          notificationMessage,
          user!.userId,
        );
      }
    } catch (e, stack) {
      log("❌ Error updating item object in SubListBloc: $e\n$stack");
    }
    resetValues();
  }

  FutureOr<void> deleteItemMethod(
    DeleteItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      await appGetit.deleteItem(item: event.item);
      log("SubListBloc: Item deleted successfully via AppDatatLayer.");
    } catch (e, stack) {
      log("❌ Error deleting item in SubListBloc: $e\n$stack");
      emit(SubListError(message: "error in delete item $e"));
    }

    resetValues();
  }

  FutureOr<void> markCheckedItemsAsCompletedMethod(
    MarkCheckedItemsAsCompletedEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      final checkedItemsToCompleteIds = checkedItemsToComplete
          .where((item) => item.status)
          .map((item) => item.itemId!)
          .toList();

      if (checkedItemsToCompleteIds.isNotEmpty) {
        log(
          "SubListBloc: Marking ${checkedItemsToCompleteIds.length} items as completed.",
        );
        await appGetit.updateItemsIsCompletedToTurue(
          itemIds: checkedItemsToCompleteIds,
        );

        emit(MarkCheckedItemsAsCompletedState());
        log("SubListBloc: Successfully marked items as completed.");
      } else {
        log("SubListBloc: No checked items to mark as completed.");
      }
    } catch (e, stack) {
      log(
        "❌ SubListBloc: Error marking checked items as completed: $e\n$stack",
      );
      emit(
        SubListError(
          message: "ubListBloc: Error marking checked items as completed: $e",
        ),
      );
    }
    resetValues();

    // appGetit.allItemsSubscription?.cancel();
    // appGetit.allListsSubscription?.cancel();
  }

  void resetValues() {
    itemController.clear();
    number = 1;
    isItemImportant = false;
    isItemsChecked = appGetit.uncompletedItemsForCurrentList.any(
      (item) => item.status,
    );
    _updateSubListState();
  }

  FutureOr<void> checkoutMethod(
    CheckoutEvent event,
    Emitter<SubListState> emit,
  ) {
    try {
      checkedItemsToComplete = appGetit.uncompletedItemsForCurrentList
          .where((item) => item.status)
          .toList();

      if (checkedItemsToComplete.isNotEmpty) {
        log(
          "SubListBloc: Marking ${checkedItemsToComplete.length} items as completed.",
        );
      }
    } catch (e, stack) {
      log(
        "❌ SubListBloc: Error marking checked items as completed: $e\n$stack",
      );
    }
  }

  FutureOr<void> onLoadCompletedItemsScreenData(
    LoadCompletedItemsScreenData event,
    Emitter<SubListState> emit,
  ) async {
    try {
      final Map<String, List<ItemModel>> completedItemsMap =
          appGetit.allCompletedItemsByListName;

      log(
        "SubListBloc: Loaded completed items map for CompletedScreen. Map size: ${completedItemsMap.length}",
      );

      emit(
        CompletedItemsLoadedState(completedItemsByListName: completedItemsMap),
      );
    } catch (e, stack) {
      log("❌ SubListBloc: Error in onLoadCompletedItemsScreenData: $e\n$stack");
      emit(
        SubListError(message: "Failed to load completed items for screen: $e"),
      );
    }
  }

  @override
  Future<void> close() {
    itemController.dispose();
    _itemsSubscription?.cancel(); // هذا هو المكان الصحيح للإلغاء
    _listsSubscription?.cancel(); // وهذا أيضاً
    appGetit.allItemsSubscription?.cancel();
    appGetit.allListsSubscription?.cancel();
    log("SubListBloc: Streams cancelled and disposed.");
    return super.close();
  }

  Future<void> initializeUserAndStreams() async {
    log("initializeUserAndStreams start");
    user = await fetchUserById();
    OneSignal.login(user!.userId);
    appGetit.initStreams(user!.userId);

    _itemsSubscription = appGetit.allItemsStream.listen(
      (items) {
        log(
          "SubListBloc: Received updated items from AppDatatLayer stream. Updating state.",
        );
        _updateSubListState();
      },
      onError: (error) {
        log("SubListBloc: Error in items stream: $error");
        emit(SubListError(message: "Failed to load items: $error"));
      },
    );

    _listsSubscription = appGetit.allListsStream.listen(
      (lists) {
        log(
          "SubListBloc: Received updated lists from AppDatatLayer stream. Updating listName.",
        );
        if (appGetit.listId != null) {
          try {
            listName = lists
                .firstWhere((list) => list.listId == appGetit.listId)
                .name;
            _updateSubListState();
          } catch (e) {
            log(
              "SubListBloc: List with ID ${appGetit.listId} not found in updated lists: $e",
            );
          }
        }
      },
      onError: (error) {
        log("SubListBloc: Error in lists stream: $error");
      },
    );
  }
}
