import 'dart:async';
import 'dart:developer';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/repository/supabase.dart';

class AppDatatLayer {
  List<ListModel> lists = [];
  List<ItemModel> items = [];

  final itemsStreamController = StreamController<List<ItemModel>>.broadcast();
  final listsStreamController = StreamController<List<ListModel>>.broadcast();

  StreamSubscription<List<ItemModel>>? allItemsSubscription;
  StreamSubscription<List<ListModel>>? allListsSubscription;

  String? listId = "c59726cd-8dc9-4285-85ef-6f6574c16b51";
  Map<String, List<ItemModel>> completedItemsByListName = {};
  AppDatatLayer();
  void initStreams(String userId) {
    log("AppDatatLayer: Initializing streams for userId: $userId");

    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();

    allItemsSubscription = SupabaseConnect.listenToAllUserItemsDirectly(userId)
        .listen(
          (updatedItems) {
            log(
              "AppDatatLayer: Received ${updatedItems.length} items from stream.",
            );
            items = updatedItems;
            itemsStreamController.add(items);
          },
          onError: (e) {
            log("AppDatatLayer: Error in all items stream: $e");
            itemsStreamController.addError(e);
          },
        );

    allListsSubscription = SupabaseConnect.listenToAllUserListsDirectly(userId)
        .listen(
          (updatedLists) {
            log(
              "AppDatatLayer: Received ${updatedLists.length} lists from stream.",
            );
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
        .where(
          (item) =>
              item.listId == listId &&
              item.isCompleted == true &&
              item.status == true,
        )
        .toList();
  }

  Map<String, List<ItemModel>> get allCompletedItemsByListName {
    final Map<String, List<ItemModel>> allListsAndCompletedItems = {};

    if (lists.isEmpty) {
      log(
        "AppDatatLayer: No user lists available to categorize completed items.",
      );
      return {};
    }

    for (var list in lists) {
      final List<ItemModel> completedItemsForThisList = items
          .where(
            (item) =>
                item.listId == list.listId &&
                item.isCompleted == true &&
                item.status == true,
          )
          .toList();

      allListsAndCompletedItems[list.name] = completedItemsForThisList;
    }
    log(
      "AppDatatLayer: Generated allCompletedItemsByListName Map. Lists: ${allListsAndCompletedItems.length}",
    );
    return allListsAndCompletedItems;
  }

  void dispose() {
    allItemsSubscription?.cancel();
    allListsSubscription?.cancel();
    itemsStreamController.close();
    listsStreamController.close();
    log("AppDatatLayer: Streams disposed.");
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
      return null; // or rethrow, based on your error handling strategy
    }
  }

  Future<ItemModel?> addNewItem({required ItemModel item}) async {
    ItemModel? newItem;
    try {
      log("item ${item.toString()} start inserting");
      newItem = await SupabaseConnect.addNewItem(item: item);
      log("item ${item.toString()} end inserting");
    } catch (e) {
      log("addNewItem Failed $e");
      rethrow;
    }
    return newItem;
  }

  Future<void> updateItem({required ItemModel item}) async {
    try {
      log("updateItem SupabaseConnect: Item ${item.itemId}start.");
      await SupabaseConnect.updateItem(item: item);
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
