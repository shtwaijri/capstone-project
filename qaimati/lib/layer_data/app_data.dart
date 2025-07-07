import 'dart:async';
import 'dart:developer';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/repository/supabase.dart';

/// This class acts as a data layer, abstracting direct Supabase calls
/// and providing streams and utility methods for the application's UI/logic.
/// It holds real-time data from Supabase and exposes it through streams.
class AppDatatLayer {
  List<ListModel> lists = []; // Holds all lists retrieved for the user
  List<ItemModel> items = []; // Holds all items retrieved for the user

  // StreamController for broadcasting real-time item updates
  final itemsStreamController = StreamController<List<ItemModel>>.broadcast();

  // StreamController for broadcasting real-time list updates
  final listsStreamController = StreamController<List<ListModel>>.broadcast();

  // Subscriptions to the Supabase streams for all items and lists
  StreamSubscription<List<ItemModel>>? allItemsSubscription;
  StreamSubscription<List<ListModel>>? allListsSubscription;

  // Currently selected list ID
  String? listId = "c59726cd-8dc9-4285-85ef-6f6574c16b51";

  // Map to store completed items, grouped by list name (used for a specific UI screen)
  Map<String, List<ItemModel>> completedItemsByListName = {};

  AppDatatLayer();

  /// Initializes the real-time streams for items and lists for the given user.
  /// This method sets up listeners to Supabase data changes.
  void initStreamsf(String userId) {
    log("AppDatatLayer: Initializing streams for userId: $userId");

    // Cancel any existing subscriptions to prevent memory leaks and duplicate listeners
    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();

    // Listen to the real-time stream of all items associated with the user.
    // When new item data arrives, update the local 'items' list and broadcast it.
    allItemsSubscription = SupabaseConnect.listenToAllUserItemsDirectly(userId)
        .listen(
          (updatedItems) {
            log(
              "AppDatatLayer: Received ${updatedItems.length} items from stream.",
            );
            items = updatedItems; // Update the local 'items' list
            itemsStreamController.add(
              items,
            ); // Broadcast the updated items to listeners
          },
          onError: (e) {
            log("AppDatatLayer: Error in all items stream: $e");
            itemsStreamController.addError(
              e,
            ); // Propagate the error to listeners
          },
        );

    // Listen to the real-time stream of all lists associated with the user.
    // When new list data arrives, update the local 'lists' list and broadcast it.
    allListsSubscription = SupabaseConnect.listenToAllUserListsDirectly(userId)
        .listen(
          (updatedLists) {
            log(
              "AppDatatLayer: Received ${updatedLists.length} lists from stream.",
            );
            lists = updatedLists; // Update the local 'lists' list
            listsStreamController.add(
              lists,
            ); // Broadcast the updated lists to listeners
          },
          onError: (e) {
            log("AppDatatLayer: Error in all lists stream: $e");
            listsStreamController.addError(
              e,
            ); // Propagate the error to listeners
          },
        );
  }

  // --- Getters for Streams and Filtered Data ---

  /// Provides a broadcast stream of all items & Lists for the user.
  /// UI components (e.g., BloC) can listen to this stream to get real-time item updates.
  Stream<List<ItemModel>> get allItemsStream => itemsStreamController.stream;
  Stream<List<ListModel>> get allListsStream => listsStreamController.stream;

  /// Returns a list of items that are NOT completed and belong to the currently selected `listId`.
  List<ItemModel> get uncompletedItemsForCurrentList {
    if (listId == null) {
      log("AppDatatLayer: No currentSelectedListId set for uncompleted items.");
      return []; // Return empty if no list is selected
    }

    /// Returns a list of items that ARE completed and have a `status` of true,
    /// belonging to the currently selected `listId`.
    return items
        .where((item) => item.listId == listId && item.isCompleted == false)
        .toList();
  }

  List<ItemModel> get completedAndTrueStatusItemsForCurrentList {
    if (listId == null) {
      log("AppDatatLayer: No currentSelectedListId set for completed items.");
      return [];
    }
    // Filters for completed items with true status
    return items
        .where(
          (item) =>
              item.listId == listId &&
              item.isCompleted == true &&
              item.status == true,
        )
        .toList();
  }

  /// Generates a map where keys are list names and values are lists of completed items
  /// belonging to that specific list. This provides a categorized view of completed items
  /// across all user's lists.
  Map<String, List<ItemModel>> get allCompletedItemsByListName {
    final Map<String, List<ItemModel>> allListsAndCompletedItems = {};

    if (lists.isEmpty) {
      log(
        "AppDatatLayer: No user lists available to categorize completed items.",
      );
      return {}; // Return empty if no lists are loaded
    }

    // Add the found completed items to the map, using the list's name as the key.
    // Assumes list.name is unique for this purpose, or handles collisions as needed.
    for (ListModel list in lists) {
      final completedItemsForThisList = items
          .where(
            (item) =>
                item.listId == list.listId &&
                item.isCompleted == true &&
                item.status == true,
          )
          .toList();
      allListsAndCompletedItems[list.listId] = completedItemsForThisList;
    }
    log(
      "AppDatatLayer: Generated allCompletedItemsByListName Map. Lists: ${allListsAndCompletedItems.length}",
    );
    return allListsAndCompletedItems;
  }

  /// Disposes of all StreamSubscriptions to prevent memory leaks when the
  void dispose() {
    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();
    log("AppDatatLayer: Subscriptions cancelled.");
  }

  // --- Passthrough Methods (Proxying calls to SupabaseConnect) ---

  /// Passes the notification request to SupabaseConnect to send push notifications
  /// to users in a specific list.
  ///
  /// [listId]: The ID of the list whose members should be notified.
  /// [notificationTitle]: The title of the notification.
  /// [notificationMessage]: The body/message of the notification.
  /// [excludeUserId]: Optional. If provided, the user with this ID will not receive the notification.

  static Future<void> notifyUsersInList(
    String listId,
    String notificationTitle,
    String notificationMessage,
    String? excludeUserId,
  ) async {
    try {
      log("notifyUsersInList app layer start");
      await SupabaseConnect.notifyUsersInList(
        listId,
        notificationTitle,
        notificationMessage,
        excludeUserId,
      );
      log("notifyUsersInList app layer sent");
    } catch (e) {
      log("notifyUsersInList app layer error $e");
    }
  }

  /// Updates the `status` (checked/unchecked) of a specific item in Supabase.
  ///
  /// [itemId]: The ID of the item to update.
  /// [status]: The new status (boolean) for the item.
  Future<void> updateItemStatus({
    required String itemId,
    required bool status,
  }) async {
    try {
      await SupabaseConnect.updateItemStatus(itemId: itemId, status: status);
      log(
        "updateItemStatusAppDataLayer✅ Updated item $itemId status to $status",
      );
    } catch (e) {
      log(
        "❌updateItemStatusAppDataLayer Failed to update status for item $itemId: $e",
      );
      rethrow;
    }
  }

  /// Retrieves the role of a specific user within a given list from Supabase.
  ///
  /// [userId]: The ID of the user.
  /// [listId]: The ID of the list.
  /// Returns the user's role (e.g., 'admin', 'member') as a String, or null if not found or on error.
  Future<String?> getUserRoleForCurrentList({
    required String userId,
    required String listId,
  }) async {
    try {
      String userRole = (await SupabaseConnect.getUserRoleForCurrentList(
        userId: userId,
        listId: listId,
      ))!;
      log("getUserRoleForCurrentList Updated userId $userId listId to $listId");
      return userRole;
    } catch (e) {
      log(
        "getUserRoleForCurrentList Failed to update status for item $userId: $e",
      );
      return null;
    }
  }

  /// Adds a new item to Supabase.
  ///
  /// [item]: The ItemModel object to be added.
  Future<void> addNewItem({required ItemModel item}) async {
    try {
      log("item ${item.toString()} start inserting");
      await SupabaseConnect.addNewItem(item: item);
      log("item ${item.toString()} end inserting");
    } catch (e) {
      log("addNewItem Failed $e");
      rethrow;
    }
  }

  /// Updates an existing item in Supabase.
  ///
  /// [item]: The ItemModel object with updated details.
  /// [listName]: The name of the list the item belongs to (may be redundant if listId is used within item).
  Future<void> updateItem({
    required ItemModel item,
    required String listName,
  }) async {
    try {
      log("updateItem SupabaseConnect: Item ${item.itemId}start.");
      await SupabaseConnect.updateItem(item: item, listName: listName);
      log("updateItem SupabaseConnect: Item ${item.itemId} end successfully ");
    } catch (_) {
      log("updateItem rethrow: ");
      rethrow;
    }
  }

  /// Deletes an item from Supabase.
  ///
  /// [item]: The ItemModel object to be deleted.
  Future<void> deleteItem({required ItemModel item}) async {
    try {
      log("deleteItem AppDatatLayer ${item.itemId}start.");
      await SupabaseConnect.deleteItem(item: item);
      log("deleteItem AppDatatLayer: Item ${item.itemId} end successfully ");
    } catch (_) {
      log("AppDatatLayer rethrow: deleteItem");
      rethrow;
    }
  }

  /// Updates the `isCompleted` status of multiple items to `true` in Supabase.
  /// Also typically sets the `closed_at` timestamp in the database.
  ///
  /// [itemIds]: A list of item IDs to be marked as completed.
  Future<void> updateItemsIsCompletedToTurue({
    required List<String> itemIds,
  }) async {
    try {
      await SupabaseConnect.updateItemsIsCompletedToTurue(itemIds: itemIds);
      log(
        "✅ updateItemsIsCompletedToTurue: Successfully updated isCompleted/closed_at for ${itemIds.length} items. in app layer",
      );
    } catch (e, stack) {
      log(
        "❌ updateItemsIsCompletedToTurue: Failed to update isCompleted/closed_at for items: $e\n$stack . in app layer",
      );
      rethrow;
    }
  }

  // =================================================== Start Admin Lists =====================================================
  Future<void> loadAdminLists() async {
    try {
      log("🔄 loadAdminLists: start");

      final adminLists = await SupabaseConnect.getAdminLists();

      // update vriabe
      lists = adminLists;

      // share data to stream
      listsStreamController.add(adminLists);

      log("✅ loadAdminLists: success — loaded ${adminLists.length} lists");

      for (final list in adminLists) {
        log(
          "📋 List: id=${list.listId}, name=${list.name}, color=${list.color}",
        );
      }
    } catch (e, stack) {
      log("❌ loadAdminLists: failed\n$e\n$stack");
      rethrow;
    }
  }

  // ================================================== End Admin Lists =====================================================
  // ================================================== Start member Items ==================================================
  Future<void> loadMemberLists() async {
    try {
      log("🔄 loadMemberLists: start");

      final memberLists = await SupabaseConnect.getMemberLists();

      // update vriabe
      lists = memberLists;

      // share data to stream
      listsStreamController.add(lists);

      log("✅ loadMemberLists: success — loaded ${lists.length} lists");

      for (final list in lists) {
        log(
          "📋 List: id=${list.listId}, name=${list.name}, color=${list.color}",
        );
      }
    } catch (e, stack) {
      log("❌ loadMemberLists: failed\n$e\n$stack");
      rethrow;
    }
  }

  // ================================================== End member Items =====================================================
  // ================================================== Start add New Lists ==================================================
  Future<void> createNewList(ListModel list) async {
    try {
      log("🟢 createNewList: started");

      final newList = await SupabaseConnect.addNewList(list: list);

      if (newList != null) {
        lists.add(newList);

        listsStreamController.add(List.from(lists));

        log(
          "✅ createNewList: success — listId=${newList.listId}, name=${newList.name}, color=${newList.color}",
        );
      } else {
        log("⚠ createNewList: no list returned");
      }
    } catch (e, stack) {
      log("❌ createNewList: failed\n$e\n$stack");
      rethrow;
    }
  }

  // ================================================== End add New Lists ====================================================
  // ================================================== Start Update Lists =====================================================
  Future<void> submitListUpdate(ListModel updatedList) async {
    try {
      log("🔄 submitListUpdate: started for listId=${updatedList.listId}");

      await SupabaseConnect.updateList(list: updatedList);

      // update data
      final index = lists.indexWhere((l) => l.listId == updatedList.listId);
      if (index != -1) {
        lists[index] = updatedList;
        listsStreamController.add(List.from(lists));
      }

      log(
        "✅ submitListUpdate: updated list ${updatedList.listId} (name=${updatedList.name}, color=${updatedList.color})",
      );
    } catch (e, stack) {
      log(
        "❌ submitListUpdate: failed to update list ${updatedList.listId}\n$e\n$stack",
      );
      rethrow;
    }
  }

  // ================================================== End Update Lists =======================================================
  // ================================================== Start Delete Lists =====================================================
  Future<void> confirmDeleteList(String listId) async {
    try {
      log("🧨 confirmDeleteList: attempting to delete list $listId");

      await SupabaseConnect.deleteList(listId: listId);

      // delete list
      lists.removeWhere(
        (l) => l.listId == listId,
      ); // 1.listid search about list and delete it
      listsStreamController.add(List.from(lists));

      log("✅ confirmDeleteList: list $listId deleted successfully");
    } catch (e, stack) {
      log("❌ confirmDeleteList: failed to delete list $listId\n$e\n$stack");
      rethrow;
    }
  }

  // ================================================== End Delete Lists =======================================================
}
