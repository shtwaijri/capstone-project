// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

part 'sub_list_event.dart';
part 'sub_list_state.dart';

/// SubListBloc manages the state and logic for a specific list,
/// including items within it, user roles, and interactions like adding/updating/deleting items.
class SubListBloc extends Bloc<SubListEvent, SubListState> {
  // --- State Variables ---
  int number = 1; // Quantityfor item
  bool isItemImportant = false; // Flag to mark an item as important
  // Flag indicating if any items are currently checked/selected
  bool isItemsChecked = false;
  // The role of the current user in the active list (e.g., 'Admin', 'Member')
  String? currentUserRole;
  String? listName; // The name of the currently active list
  AppUserModel? user; // The currently authenticated application user
  // List of items marked for completion/checkout
  List<ItemModel> checkedItemsToComplete = [];
  // Controller for item name input field
  TextEditingController itemController = TextEditingController();
  // GlobalKey for managing the form state
  final formKey = GlobalKey<FormState>();

  // --- Dependency Injection via GetIt ---
  final appGetit = GetIt.I.get<AppDatatLayer>();

  // --- Stream Subscriptions ---
  // These subscriptions listen to real-time updates from the AppDatatLayer.
  StreamSubscription<List<ItemModel>>? _itemsSubscription;
  StreamSubscription<List<ListModel>>? _listsSubscription;

  SubListBloc() : super(SubListInitial()) {
    // Event handler for loading initial screen data.
    // This is called when the SubList screen is first loaded or needs to refresh its main data.
    on<LoadSubListScreenData>((event, emit) async {
      await initializeUserAndStreams(); // Ensure user and data streams are set up
      await _loadInitialScreenData(
        emit,
      ); // Load other initial data (list name, user role, completed items)
      _updateSubListState(); // Update the UI state with the loaded data
    });

    // Register handlers for various events
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

  /// Updates the BLoC's state based on the current data from `appGetit`.
  /// This method is called whenever internal data changes that should reflect on the UI.
  void _updateSubListState() {
    // Ensure a list is selected before attempting to update state related to items.
    // if (appGetit.listId == null) {
    //   log("SubListBloc: _currentListId is null, cannot update item state.");
    //   emit(SubListError(message: "No list selected."));
    //   return;
    // }

    // Get uncompleted and completed items for the currently selected list.
    final uncompletedItems = appGetit.uncompletedItemsForCurrentList;
    isItemsChecked = uncompletedItems.any((item) => item.status);
    // Emit a new state to update the UI.
    emit(
      SubListLoadedState(
        uncompletedItems: uncompletedItems,
        currentNumber: number,
        currentIsItemImportant: isItemImportant,
        isItemsChecked: isItemsChecked,
        currentUserRole: currentUserRole,
        listName: listName,
      ),
    );
  }

  /// Loads initial data for the SubList screen, such as list name, user role,
  /// and completed items map for the dedicated completed items screen.
  Future<void> _loadInitialScreenData(Emitter<SubListState> emit) async {
    emit(SubListLoading()); // Emit loading state
    try {
      // Check if a list ID is set (i.e., a list is selected).
      if (appGetit.listId != null) {
        try {
          //get tha name of list
          listName = appGetit.lists
              .firstWhere((list) => list.listId == appGetit.listId)
              .name;
          //retrun latter
        } catch (e) {
          // If the list name isn't found (e.g., list not in `appGetit.lists`),
          // set a generic default name.
          log(
            "SubListBloc: Could not find list name for ${appGetit.listId}: $e",
          );
          listName = "List".tr(); // Localized default name
        }

        // Fetch the current user's role for the selected list.
        // This is crucial for permission-based UI elements.
        currentUserRole = await appGetit.getUserRoleForCurrentList(
          userId: user!.userId,
          listId: appGetit.listId!,
        );
      }
    } catch (e, stack) {
      log("❌ SubListBloc: Error during initial screen data load: $e\n$stack");
      // Catch any general errors during initial data loading.
      emit(SubListError(message: "Failed to load initial data: $e"));
    }
  }

  /// Event handler for `ToggleItemCheckedEvent`.
  /// Updates the `status` (checked state) of an item in the database.
  FutureOr<void> toggleItemCheckedMethod(
    ToggleItemCheckedEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      // Delegate the actual database update to the AppDatatLayer.
      await appGetit.updateItemStatus(
        itemId: event.itemId!,
        status: event.isChecked,
      );

      _updateSubListState(); // Update the UI state with the loaded data
    } catch (e, stack) {
      // Error is logged, but not rethrown to prevent UI from breaking on a single item update error.
      log("❌ SubListBloc: Error toggling item status: $e\n$stack");
    }
  }

  /// Event handler for `AddItemToListEvent`.
  /// Creates a new item and adds it to the database, then potentially triggers notifications.
  FutureOr<void> addItemToListMethod(
    AddItemToListEvent event,
    Emitter<SubListState> emit,
  ) async {
    log("--- SubListBloc: Handling AddItemToListEvent ---");
    log(
      "Item Name: ${event.itemName}, Quantity: ${event.quantity}, Important: ${event.isImportant}, Created By: ${event.createdBy}",
    );

    try {
      log("SubListBloc: Calling addNewItem in AppDatatLayer...");
      // Create a new ItemModel instance with the provided event data and default values.
      await appGetit.addNewItem(
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

      log("SubListBloc: Notification process initiated successfully.");
    } catch (e, stack) {
      log("❌ SubListBloc: Error during notification process: $e\n$stack");
    }
    resetValues(); // Reset UI input values and update state.
  }

  /// Increments the `number` state variable (for item quantity).

  void _incrementNumber(
    IncrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    number++;
    _updateSubListState(); // Update UI to reflect new number.
  }

  /// Decrements the `number` state variable, ensuring it doesn't go below 1.

  void _decrementNumber(
    DecrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    if (number > 1) {
      number--;
      _updateSubListState(); // Update UI to reflect new number.
    }
  }

  /// Sets the `isItemImportant` flag based on user input.
  /// then Update UI to reflect new importance status.
  void chooseImportance(
    ChooseImportanceEvent event,
    Emitter<SubListState> emit,
  ) {
    isItemImportant = event.isImportant;
    _updateSubListState();
  }

  /// Event handler for `UpdateItemEvent`.
  /// Updates an existing item's details in the database.
  FutureOr<void> updateItemMethod(
    UpdateItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    // Create a copy of the item with updated details from the UI controllers.
    ItemModel editedItem = event.editedItem.copyWith(
      title: itemController.text,
      quantity: number,
      important: isItemImportant,
    );

    try {
      // Delegate the update operation to the AppDatatLayer.
      await appGetit.updateItem(item: editedItem, listName: listName!);
      log("SubListBloc: Item updated successfully via AppDatatLayer.");
    } catch (e, stack) {
      log("❌ Error updating item object in SubListBloc: $e\n$stack");
    }
    resetValues(); // Reset UI input values and update state.
  }

  /// Event handler for `DeleteItemEvent`.
  /// Deletes an item from the database.
  FutureOr<void> deleteItemMethod(
    DeleteItemEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      await appGetit.deleteItem(
        item: event.item,
      ); // Reset UI input values and update state.
      log("SubListBloc: Item deleted successfully via AppDatatLayer.");
    } catch (e, stack) {
      log("❌ Error deleting item in SubListBloc: $e\n$stack");
      // Emit error state
      emit(SubListError(message: "error in delete item $e"));
    }

    resetValues(); // Reset UI input values and update state.
  }

  /// Event handler for `MarkCheckedItemsAsCompletedEvent`.
  /// Marks all currently checked items as `isCompleted = true` in the database.
  FutureOr<void> markCheckedItemsAsCompletedMethod(
    MarkCheckedItemsAsCompletedEvent event,
    Emitter<SubListState> emit,
  ) async {
    try {
      // Filter the `checkedItemsToComplete` list to get only the IDs of items that are checked.
      final checkedItemsToCompleteIds = checkedItemsToComplete
          .where((item) => item.status)
          .map((item) => item.itemId!)
          .toList();

      if (checkedItemsToCompleteIds.isNotEmpty) {
        log(
          "SubListBloc: Marking ${checkedItemsToCompleteIds.length} items as completed.",
        );
        // Delegate the bulk update operation to AppDatatLayer.
        await appGetit.updateItemsIsCompletedToTurue(
          itemIds: checkedItemsToCompleteIds,
        );

        emit(
          MarkCheckedItemsAsCompletedState(),
        ); // Emit a state to acknowledge completion
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
          // Emit error state
          message: "ubListBloc: Error marking checked items as completed: $e",
        ),
      );
    }
    resetValues(); // Reset UI input values and update state.

    close();
  }

  /// Resets various UI-related state variables to their default values.
  /// Also recalculates `isItemsChecked` and updates the BLoC's state.
  void resetValues() {
    itemController.clear(); // Clear the item input field
    number = 1;
    isItemImportant = false;
    isItemsChecked = appGetit.uncompletedItemsForCurrentList.any(
      (item) => item.status, //check if there attribute is checked
    );
    _updateSubListState(); // Trigger a state update to reflect changes on the UI.
  }

  /// Event handler for `CheckoutEvent`.
  /// Populates the `checkedItemsToComplete` list with currently checked items.
  FutureOr<void> checkoutMethod(
    CheckoutEvent event,
    Emitter<SubListState> emit,
  ) {
    try {
      // Filter uncompleted items to get only those that are currently checked.
      checkedItemsToComplete = appGetit.uncompletedItemsForCurrentList
          .where(
            (item) => item.status,
          ) // `item.status` refers to the checkbox state here
          .toList();

      if (checkedItemsToComplete.isNotEmpty) {
        log(
          "SubListBloc: Marking ${checkedItemsToComplete.length} items as completed.",
        );
      }
      //emit(CheckoutState()); //emit state to update UI
    } catch (e, stack) {
      log(
        "❌ SubListBloc: Error marking checked items as completed: $e\n$stack",
      );
      // emit(
      //   SubListError(message: " Error marking checked items as completed: $e"),
      // ); //emite state for error
    }
  }

  /// Event handler for `LoadCompletedItemsScreenData`.
  /// This loads and organizes all completed items across all lists for display on a dedicated screen.
  FutureOr<void> onLoadCompletedItemsScreenData(
    LoadCompletedItemsScreenData event,
    Emitter<SubListState> emit,
  ) async {
    try {
      // Get the map of completed items categorized by list name from the AppDatatLayer.
      final Map<String, List<ItemModel>> completedItemsMap =
          appGetit.allCompletedItemsByListName;

      log(
        "SubListBloc: Loaded completed items map for CompletedScreen. Map size: ${completedItemsMap.length}",
      );
      // Emit a specific state to display the loaded completed items.
      emit(
        CompletedItemsLoadedState(completedItemsByListName: completedItemsMap),
      );
    } catch (e, stack) {
      log("❌ SubListBloc: Error in onLoadCompletedItemsScreenData: $e\n$stack");
      emit(
        SubListError(
          message: "Failed to load completed items for screen: $e",
        ), //emite state for error
      );
    }
  }

  /// Overrides the `close` method from `Bloc` to clean up resources when the BLoC is closed.
  @override
  Future<void> close() {
    itemController.dispose(); // Dispose the text editing controller
    // Cancel the BLoC's own subscriptions to the AppDatatLayer's streams.
    _itemsSubscription?.cancel();
    _listsSubscription?.cancel();

    log("SubListBloc: Streams cancelled and disposed.");
    return super.close();
  }

  /// Initializes the user object and sets up real-time stream listeners from `AppDatatLayer`.
  /// This is critical for fetching user data and enabling real-time updates.
  Future<void> initializeUserAndStreams() async {
    log("initializeUserAndStreams start");
    user = await fetchUserById(); // Fetch the authenticated user's details.
    // Log in the user to OneSignal with their external ID (user ID).
    // This connects the device's push notification token to the user's ID in OneSignal.
    try {
      OneSignal.login(user!.userId);
      appGetit.initStreamsf(
        user!.userId,
      ); // Initialize the data streams in the AppDatatLayer for the fetched user.
    } catch (e) {
      log("error $e");
    }
    // Subscribe to the AppDatatLayer's items stream.
    // This BLoC acts as a listener for item updates from the AppDatatLayer.
    _itemsSubscription = appGetit.allItemsStream.listen(
      (items) {
        log(
          "SubListBloc: Received updated items from AppDatatLayer stream. Updating state.",
        );
        _updateSubListState(); // When items update, trigger a state update in the BLoC.
      },
      onError: (error) {
        log("SubListBloc: Error in items stream: $error");
        emit(
          SubListError(message: "Failed to load items: $error"),
        ); // Emit error state.
      },
    );

    // Subscribe to the AppDatatLayer's lists stream.
    // This BLoC acts as a listener for list updates from the AppDatatLayer.
    _listsSubscription = appGetit.allListsStream.listen(
      (lists) {
        log(
          "SubListBloc: Received updated lists from AppDatatLayer stream. Updating listName.",
        );
        // If a list is currently selected, try to find its name from the updated lists.
        if (appGetit.listId != null) {
          try {
            listName = lists
                .firstWhere((list) => list.listId == appGetit.listId)
                .name;
            _updateSubListState(); // Update state if list name is found/updated.
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
