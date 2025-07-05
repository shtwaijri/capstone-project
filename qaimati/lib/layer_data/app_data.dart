import 'dart:async';
import 'dart:developer';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/repository/supabase.dart';

class AppDatatLayer {
  List<ListModel> lists = [];
  List<ItemModel> items = [];

  // StreamControllers (لن تغلقها أبداً)
  final itemsStreamController = StreamController<List<ItemModel>>.broadcast();
  final listsStreamController = StreamController<List<ListModel>>.broadcast();

  StreamSubscription<List<ItemModel>>? allItemsSubscription;
  StreamSubscription<List<ListModel>>? allListsSubscription;

  String? listId = "c59726cd-8dc9-4285-85ef-6f6574c16b51";

  Map<String, List<ItemModel>> completedItemsByListName = {};

  AppDatatLayer();

  void initStreams(String userId) {
    log("AppDatatLayer: Initializing streams for userId: $userId");

    // إذا كانت هناك اشتراكات قديمة، نلغيها أولاً
    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();

    allItemsSubscription =
        SupabaseConnect.listenToAllUserItemsDirectly(userId).listen(
      (updatedItems) {
        log("AppDatatLayer: Received ${updatedItems.length} items from stream.");
        items = updatedItems;
        itemsStreamController.add(items);
      },
      onError: (e) {
        log("AppDatatLayer: Error in all items stream: $e");
        itemsStreamController.addError(e);
      },
    );

    allListsSubscription =
        SupabaseConnect.listenToAllUserListsDirectly(userId).listen(
      (updatedLists) {
        log("AppDatatLayer: Received ${updatedLists.length} lists from stream.");
        lists = updatedLists;
        listsStreamController.add(lists);
      },
      onError: (e) {
        log("AppDatatLayer: Error in all lists stream: $e");
        listsStreamController.addError(e);
      },
    );
  }

  Stream<List<ItemModel>> get allItemsStream => itemsStreamController.stream;
  Stream<List<ListModel>> get allListsStream => listsStreamController.stream;

  List<ItemModel> get uncompletedItemsForCurrentList {
    if (listId == null) {
      log("AppDatatLayer: No currentSelectedListId set for uncompleted items.");
      return [];
    }
    return items
        .where((item) => item.listId == listId && item.isCompleted == false)
        .toList();
  }

  List<ItemModel> get completedAndTrueStatusItemsForCurrentList {
    if (listId == null) {
      log("AppDatatLayer: No currentSelectedListId set for completed items.");
      return [];
    }
    return items
        .where((item) =>
            item.listId == listId && item.isCompleted == true && item.status == true)
        .toList();
  }

  Map<String, List<ItemModel>> get allCompletedItemsByListName {
    final Map<String, List<ItemModel>> allListsAndCompletedItems = {};

    if (lists.isEmpty) {
      log("AppDatatLayer: No user lists available to categorize completed items.");
      return {};
    }

    for (var list in lists) {
      final completedItemsForThisList = items
          .where((item) =>
              item.listId == list.listId &&
              item.isCompleted == true &&
              item.status == true)
          .toList();
      allListsAndCompletedItems[list.name] = completedItemsForThisList;
    }
    log(
      "AppDatatLayer: Generated allCompletedItemsByListName Map. Lists: ${allListsAndCompletedItems.length}",
    );
    return allListsAndCompletedItems;
  }

  void dispose() {
    // فقط نلغي الاشتراكات، لكن لا تغلق الـStreamControllers
    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();
    log("AppDatatLayer: Subscriptions cancelled.");
  }

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

  Future<void> updateItemStatus({
    required String itemId,
    required bool status,
  }) async {
    try {
      await SupabaseConnect.updateItemStatus(
        itemId: itemId,
        status: status,
      );
      log("updateItemStatusAppDataLayer✅ Updated item $itemId status to $status");
    } catch (e) {
      log("❌updateItemStatusAppDataLayer Failed to update status for item $itemId: $e");
      rethrow;
    }
  }

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
      log("getUserRoleForCurrentList Failed to update status for item $userId: $e");
      return null;
    }
  }

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

  Future<void> updateItem({required ItemModel item, required String listName}) async {
    try {
      log("updateItem SupabaseConnect: Item ${item.itemId}start.");
      await SupabaseConnect.updateItem(item: item, listName: listName);
      log("updateItem SupabaseConnect: Item ${item.itemId} end successfully ");
    } catch (_) {
      log("updateItem rethrow: ");
      rethrow;
    }
  }

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
}


// import 'dart:async';
// import 'dart:developer';
// import 'package:qaimati/models/item/item_model.dart';
// import 'package:qaimati/models/list/list_model.dart';
// import 'package:qaimati/repository/supabase.dart';

// /// This class acts as a data layer, abstracting direct Supabase calls
// /// and providing streams and utility methods for the application's UI/logic.
// /// It holds real-time data from Supabase and exposes it through streams.
// class AppDatatLayer {


  





















  
//   // Holds all lists retrieved for the user
//   List<ListModel> lists = [];

//   // Holds all items retrieved for the user
//   List<ItemModel> items = [];

//   // StreamController for broadcasting real-time item updates
//   final itemsStreamController = StreamController<List<ItemModel>>.broadcast();

//   // StreamController for broadcasting real-time list updates
//   final listsStreamController = StreamController<List<ListModel>>.broadcast();

//   // Subscriptions to the Supabase streams
//   StreamSubscription<List<ItemModel>>? allItemsSubscription;
//   StreamSubscription<List<ListModel>>? allListsSubscription;

//   // Currently selected list ID (example default value)
//   String? listId = "c59726cd-8dc9-4285-85ef-6f6574c16b51";

//   // Map of completed items grouped by list name
//   Map<String, List<ItemModel>> completedItemsByListName = {};
//   AppDatatLayer();

//   /// Initializes the real-time streams for items and lists for the given user
//   void initStreams(String userId) {
//     log("AppDatatLayer: Initializing streams for userId: $userId");

//     // Cancel previous subscriptions if any
//     // allItemsSubscription?.cancel();
//     // allListsSubscription?.cancel();

//     // Start listening to the real-time stream of all items associated with the user.
//     // The `listenToAllUserItemsDirectly` method (from SupabaseConnect) provides the raw stream.
//     allItemsSubscription = SupabaseConnect.listenToAllUserItemsDirectly(userId).listen(
//       (updatedItems) {
//         log(
//           "AppDatatLayer: Received ${updatedItems.length} items from stream.",
//         );
//         items =
//             updatedItems; // 1. Update the local `items` list with the latest data.
//         // 2. Add the updated list of items to the `itemsStreamController`,
//         //    which then broadcasts it to all its listeners.
//         itemsStreamController.add(items);
//       },
//       onError: (e) {
//         log("AppDatatLayer: Error in all items stream: $e");
//         // 1. Add the error to the `itemsStreamController` so listeners can handle it.

//         itemsStreamController.addError(e);
//       },
//     );

//     // Start listening to the real-time stream of all lists associated with the user.
//     // Similar logic as the items stream.
//     allListsSubscription = SupabaseConnect.listenToAllUserListsDirectly(userId)
//         .listen(
//           (updatedLists) {
//             log(
//               "AppDatatLayer: Received ${updatedLists.length} lists from stream.",
//             );
//             lists = updatedLists; // 1. Update the local `lists` list.
//             listsStreamController.add(
//               lists,
//             ); // 2. Add the updated list of lists to the `listsStreamController` for broadcasting.
//           },
//           onError: (e) {
//             log("AppDatatLayer: Error in all lists stream: $e");
//             listsStreamController.addError(
//               e,
//             ); // 1. Add the error to the `listsStreamController`.
//           },
//         );
//   }

//   // --- Getters for Streams and Filtered Data ---

//   /// Provides a broadcast stream of all items for the user.
//   /// UI components can listen to this stream to get real-time item updates.
//   Stream<List<ItemModel>> get allItemsStream => itemsStreamController.stream;

//   /// Provides a broadcast stream of all lists for the user.
//   /// UI components can listen to this stream to get real-time list updates.
//   Stream<List<ListModel>> get allListsStream => listsStreamController.stream;

//   /// Returns a list of items that are NOT completed and belong to the `currentSelectedListId`.
//   List<ItemModel> get uncompletedItemsForCurrentList {
//     if (listId == null) {
//       log("AppDatatLayer: No currentSelectedListId set for uncompleted items.");
//       return [];
//     }
//     return items
//         .where((item) => item.listId == listId && item.isCompleted == false)
//         .toList();
//   }

//   /// Returns a list of items that ARE completed and have a `status` of true,
//   /// belonging to the `currentSelectedListId`.

//   List<ItemModel> get completedAndTrueStatusItemsForCurrentList {
//     if (listId == null) {
//       // If no list is currently selected, return an empty list and log a message.

//       log("AppDatatLayer: No currentSelectedListId set for completed items.");
//       return [];
//     }
//     // Filter the `items` list based on `listId` and `isCompleted` status.
//     return items
//         .where(
//           (item) =>
//               item.listId == listId &&
//               item.isCompleted == true &&
//               item.status == true,
//         )
//         .toList();
//   }

//   /// Generates a map where keys are list names and values are lists of completed items
//   /// belonging to that specific list. This provides a categorized view of completed items
//   /// across all user's lists.
//   Map<String, List<ItemModel>> get allCompletedItemsByListName {
//     final Map<String, List<ItemModel>> allListsAndCompletedItems = {};

//     if (lists.isEmpty) {
//       // If no lists are loaded for the user, return an empty map and log.

//       log(
//         "AppDatatLayer: No user lists available to categorize completed items.",
//       );
//       return {};
//     }

//     for (var list in lists) {
//       // Iterate through each list the user is associated with.
//       final List<ItemModel> completedItemsForThisList = items
//           .where(
//             (item) =>
//                 item.listId == list.listId &&
//                 item.isCompleted == true &&
//                 item.status == true,
//           )
//           .toList();
//       // Add the found completed items to the map, using the list's name as the key.
//       allListsAndCompletedItems[list.name] = completedItemsForThisList;
//     }
//     log(
//       "AppDatatLayer: Generated allCompletedItemsByListName Map. Lists: ${allListsAndCompletedItems.length}",
//     );
//     return allListsAndCompletedItems;
//   }

//   // --- Resource Management ---

//   /// Disposes of all StreamControllers and cancels all StreamSubscriptions
//   /// to prevent memory leaks when the AppDatatLayer is no longer needed (e.g., user logs out).
//   void dispose() {
//     allItemsSubscription?.cancel();
//     allListsSubscription?.cancel();
//     itemsStreamController.close();
//     listsStreamController.close();
//     log("AppDatatLayer: Streams disposed.");
//   }

//   // --- Passthrough Methods (Proxying calls to SupabaseConnect) ---

//   /// Passes the notification request to SupabaseConnect to send push notifications
//   /// to users in a specific list.
//   ///
//   /// [listId]: The ID of the list whose members should be notified.
//   /// [notificationTitle]: The title of the notification.
//   /// [notificationMessage]: The body/message of the notification.

//   static Future<void> notifyUsersInList(
//     String listId,
//     String notificationTitle,
//     String notificationMessage,
//     String? excludeUserId,
//   ) async {
//     try {
//       log("notifyUsersInList app layer start");
//       await SupabaseConnect.notifyUsersInList(
//         listId,
//         notificationTitle,
//         notificationMessage,
//         excludeUserId,
//       );
//       log("notifyUsersInList app layer sent");
//     } catch (e) {
//       log("notifyUsersInList app layer error $e");
//     }
//   }

//   /// Updates the `status` of a specific item in Supabase.
//   /// take 2 parameter
//   ///
//   /// [itemId]: The ID of the item to update.
//   /// [status]: The new status (boolean) for the item.
//   Future<void> updateItemStatus({
//     required String itemId,
//     required bool status,
//   }) async {
//     try {
//       await SupabaseConnect.updateItemStatus(
//         itemId: itemId,
//         status: status,
//       ); //call updateItemStatus in SupabaseConnect
//       log(
//         "updateItemStatusAppDataLayer✅ Updated item $itemId status to $status",
//       );
//     } catch (e) {
//       log(
//         "❌updateItemStatusAppDataLayer Failed to update status for item $itemId: $e",
//       );
//       rethrow; //rethrow Exception
//     }
//   }

//   Future<String?> getUserRoleForCurrentList({
//     required String userId,
//     required String listId,
//   }) async {
//     try {
//       String userRole = (await SupabaseConnect.getUserRoleForCurrentList(
//         userId: userId,
//         listId: listId,
//       ))!;
//       log("getUserRoleForCurrentList Updated userId $userId listId to $listId");
//       return userRole;
//     } catch (e) {
//       log(
//         "getUserRoleForCurrentList Failed to update status for item $userId: $e",
//       );
//       return null; // or rethrow, based on your error handling strategy
//     }
//   }

//   /// Adds a new item to Supabase.
//   ///
//   /// [item]: The ItemModel object to be added.
//   /// Returns the newly created ItemModel with its generated ID, or null on failure.
//  Future<void> addNewItem({required ItemModel item}) async {
   
//     try {
//       log("item ${item.toString()} start inserting");
//      await SupabaseConnect.addNewItem(item: item);
//       log("item ${item.toString()} end inserting");
//     } catch (e) {
//       log("addNewItem Failed $e");
//       rethrow; // Re-throw the error to the calling layer.
//     }
  
//   }

//   /// Updates an existing item in Supabase.
//   ///
//   /// [item]: The ItemModel object with updated details.
//   Future<void> updateItem({required ItemModel item,required  String listName}) async {
//     try {
//       log("updateItem SupabaseConnect: Item ${item.itemId}start.");
//       await SupabaseConnect.updateItem(item: item,listName:listName);
//       log("updateItem SupabaseConnect: Item ${item.itemId} end successfully ");
//     } catch (_) {
//       log("updateItem rethrow: ");
//       rethrow; // Re-throw the error to the calling layer.
//     }
//   }

//   /// Deletes an item from Supabase.
//   ///
//   /// [item]: The ItemModel object to be deleted.
//   Future<void> deleteItem({required ItemModel item}) async {
//     try {
//       log("deleteItem AppDatatLayer ${item.itemId}start.");
//       await SupabaseConnect.deleteItem(item: item);
//       log("deleteItem AppDatatLayer: Item ${item.itemId} end successfully ");
//     } catch (_) {
//       log("AppDatatLayer rethrow: deleteItem");
//       rethrow;
//     }
//   }

//   /// Updates the `isCompleted` status of multiple items to `true` in Supabase.
//   /// Also sets the `closed_at` timestamp.
//   ///
//   /// [itemIds]: A list of item IDs to be marked as completed.
//   Future<void> updateItemsIsCompletedToTurue({
//     required List<String> itemIds,
//   }) async {
//     try {
//       await SupabaseConnect.updateItemsIsCompletedToTurue(itemIds: itemIds);

//       log(
//         "✅ updateItemsIsCompletedToTurue: Successfully updated isCompleted/closed_at for ${itemIds.length} items. in app layer",
//       );
//     } catch (e, stack) {
//       log(
//         "❌ updateItemsIsCompletedToTurue: Failed to update isCompleted/closed_at for items: $e\n$stack . in app layer",
//       );
//       rethrow;
//     }
//   }
// }
