import 'dart:developer';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/repository/supabase.dart';

class AppDatatLayer {
  List<ListModel> lists = [];
  List<ItemModel> items = [];
  String? listId = "c59726cd-8dc9-4285-85ef-6f6574c16b51";

  Future<void> getListsApp({required String userId}) async {
    try {
      log("start fetch in AppDatatLayer ");

      final (fetchedLists, fetchedItems) = await SupabaseConnect.getUserData(
        userId,
      );

      lists = fetchedLists;
      items = fetchedItems;

      log("end  fetch data    AppDatatLayer");
    } catch (_) {
      log("❌ Failed in getListsApp AppDatatLayer");
      rethrow;
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
        "❌updateItemStatusAppDataLayer  Failed to update status for item $itemId: $e",
      );
    }
  }

  Future<String?> getUserRoleForCurrentList({
    required String userId,
    required String listId,
  }) async {
    String userRole = "";
    try {
      userRole = (await SupabaseConnect.getUserRoleForCurrentList(
        userId: userId,
        listId: listId,
      ))!;
      log("getUserRoleForCurrentList Updated userId $userId listId to $listId");
    } catch (e) {
      log(
        "getUserRoleForCurrentList  Failed to update status for item $userId: $e",
      );
    }
    return userRole;
  }

  Future<ItemModel?> addNewItem({required ItemModel item}) async {
    ItemModel? newItem;
    try {
      log(" item ${item.toString()} start inserting");
      newItem = await SupabaseConnect.addNewItem(item: item);
      log(" item ${item.toString()} end inserting");
    } catch (e) {
      log("addNewItem  Failed $e");
      rethrow;
    }

    return newItem;
  }

  Future<void> updateItem({required ItemModel item}) async {
    try {
      log("updateItem  SupabaseConnect: Item ${item.itemId}start.");
      await SupabaseConnect.updateItem(item: item);
      log(
        "updateItem  SupabaseConnect: Item ${item.itemId} end  successfully ",
      );
    } catch (_) {
      log("updateItem  rethrow: ");

      rethrow;
    }
  }

  Future<void> deleteItem({required ItemModel item}) async {
    try {
      log("deleteItem  AppDatatLayer ${item.itemId}start.");
      await SupabaseConnect.deleteItem(item: item);
      log(
        "deleteItem  AppDatatLayer: Item ${item.itemId} end  successfully ",
      );
    } catch (_) {
      log("AppDatatLayer  rethrow: deleteItem");

      rethrow;
    }
  }
}
