import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnect {
  static SupabaseClient? supabase;
  static Future<void> init() async {
    log('start Supabase init');
    try {
      await Supabase.initialize(
        anonKey: dotenv.env['anonKey'].toString(),
        url: dotenv.env['url'].toString(),
      );

      supabase = Supabase.instance.client;

      log('end Supabase init');
      log('supabase client: $supabase');
    } catch (e) {
      log('Error in Supabase init: $e');
      throw FormatException('error in db initialization: $e');
    }
  }

  static Future<(List<ListModel>, List<ItemModel>)> getUserData(
    String userId,
  ) async {
    try {
      log("🔄 Fetching roles and lists for user: $userId");

      final listRolesResponse = await supabase!
          .from('list_user_role')
          .select('*, roles(*), list(*)')
          .eq('app_user_id', userId);

      if (listRolesResponse.isEmpty) {
        log("🚫 No roles/lists found for this user.");
        return (<ListModel>[], <ItemModel>[]); // ترجع قوائم فاضية
      }

      List<ListModel> lists = [];
      List<String> listIds = [];

      for (var item in listRolesResponse) {
        final listMap = item['list'];
        if (listMap != null) {
          final list = ListModelMapper.fromMap(listMap);
          lists.add(list);
          listIds.add(list.listId);
          log("📋 List: ${list.name} (${list.listId})");
        }

        final role = item['roles'];
        if (role != null) {
          log("🔐 Role: ${role['name']} (${role['roles_id']})");
        }
      }

      log("📦 Fetching items in user’s lists...");
      final itemsResponse = await supabase!
          .from('item')
          .select('*')
          .inFilter('list', listIds);

      List<ItemModel> items = [];
      if (itemsResponse.isNotEmpty) {
        items = itemsResponse.map((e) => ItemModelMapper.fromMap(e)).toList();
        for (var item in items) {
          log("✅ Item: ${item.title} (ID: ${item.itemId})");
        }
      }

      return (lists, items);
    } catch (e, stack) {
      log("❌ Error fetching user data: $e\n$stack");
      throw Exception("Failed to fetch user-related data: $e");
    }
  }

  static Future<void> updateItemStatus({
    required String itemId,
    required bool status,
  }) async {
    try {
      await SupabaseConnect.supabase!
          .from('item')
          .update({'status': status})
          .eq('item_id', itemId);
      log("✅ Updated item $itemId status to $status");
    } catch (e) {
      log("❌ Failed to update status for item $itemId: $e");
    }
  }

  static Future<String?> getUserRoleForCurrentList({
    required String userId,
    required String listId,
  }) async {
    try {
      final response = await supabase!
          .from('list_user_role')
          .select('roles(name)')
          .eq('app_user_id', userId)
          .eq('list_id', listId)
          .single();

      if (response != null &&
          response['roles'] != null &&
          response.isNotEmpty) {
        final roleName = response['roles']['name'];
        log("🎯 Role for user in list: $roleName");
        return roleName;
      } else {
        log("❌ No role found for this user in the list");
        return null;
      }
    } catch (e) {
      log("🚨 Error getting role for user: $e");
      return null;
    }
  }

  static Future<AppUserModel?> getUser(String userId) async {
    try {
      log("📥 Fetching user from Supabase: $userId");

      final response = await supabase!
          .from('app_user')
          .select()
          .eq('user_id', userId)
          .single(); // 👈 هذا يرجع سجل واحد فقط

      if (response.isEmpty) {
        log("🚫 No user found with ID: $userId");
        return null;
      }

      final user = AppUserModelMapper.fromMap(response);
      log("✅ User fetched: ${user.name}");
      return user;
    } catch (e, stack) {
      log("❌ Error fetching user: $e\n$stack");
      return null;
    }
  }

  static Future<ItemModel?> addNewItem({required ItemModel item}) async {
    try {
      log("start addNewItem");

      final itemMap = item.toMap();

      // ✅ احذف item_id إذا كانت null (حتى يستخدم DEFAULT في قاعدة البيانات)
      if (item.itemId == null) {
        itemMap.remove('item_id');
      }

      final response = await supabase!.from('item').insert(itemMap).select();

      if (response.isNotEmpty) {
        log("response addNewItem isNotEmpty");
        final newItem = ItemModelMapper.fromMap(response.first);
        log("newItem ${newItem.toString()}");
        log("response addNewItem ItemModelMapper correct ");
        return newItem;
      }
    } catch (e, stack) {
      log('❌ Error inserting item: $e\n$stack');
      throw Exception('Failed to add new item');
    }
    return null;
  }

  static Future<void> updateItem({required ItemModel item}) async {
    try {
      await supabase!
          .from('item')
          .update(item.toMap())
          .eq('item_id', item.itemId!);

      log("✅ SupabaseConnect: Item ${item.itemId} updated successfully in DB.");
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update item ${item.itemId} in DB: $e\n$stack",
      );
      throw Exception("Failed to update item in Supabase: $e");
    }
  }
  
  static Future<void> deleteItem({required ItemModel item}) async {
    try {
      await supabase!
          .from('item')
         .delete()
        .eq('item_id', item.itemId!);

      log("✅ SupabaseConnect: Item ${item.itemId} updated successfully in DB.");
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update item ${item.itemId} in DB: $e\n$stack",
      );
      throw Exception("Failed to update item in Supabase: $e");
    }
  }

}




//   static Future<ItemModel?> addNewItem({required ItemModel item}) async {


//     final itemmap=item.toMap();
    
//     try {
//       log("start addNewItem");
//       final response = await supabase!
//           .from('item')
//           .insert(item.toMap())
//           .select();

//       if (response.isNotEmpty) {
//         log("response addNewItem isNotEmpty");
//         final newItem = ItemModelMapper.fromMap(response.first);
//         log("newItem ${newItem.toString()}");
//         log("response addNewItem ItemModelMapper corect ");
//         return newItem;
//       }
//     } catch (e, stack) {
//       log('❌ Error inserting item: $e\n$stack');
//       throw Exception('Failed to add new item');
//     }
//     return null;
//   }
// }
  // static Future<void> getUserData(String userId) async {
  //   try {
  //     log("🔄 Fetching roles and lists for user: $userId");

  //     // Step 1: Get lists and roles from list_user_role
  //     final listRolesResponse = await supabase!
  //         .from('list_user_role')
  //         .select('*, roles(*), list(*)')
  //         .eq('app_user_id', userId);

  //     if (listRolesResponse.isEmpty) {
  //       log("🚫 No roles/lists found for this user.");
  //       return;
  //     }

  //     // Collect list IDs to fetch items later
  //     final List<String> listIds = [];

  //     for (var item in listRolesResponse) {
  //       final role = item['roles'];
  //       final list = item['list'];

  //       log("📋 List: ${list['name']} (${list['list_id']})");
  //       log("🔐 Role: ${role['name']} (${role['roles_id']})");

  //       if (list['list_id'] != null) {
  //         listIds.add(list['list_id']);
  //       }
  //     }

  //     // Step 2: Fetch items based on list IDs
  //     log("📦 Fetching items in user’s lists...");

  //     final itemsResponse = await supabase!
  //         .from('item')
  //         .select('*')
  //         .inFilter('list', listIds);

  //     if (itemsResponse.isEmpty) {
  //       log("🚫 No items found for these lists.");
  //     } else {
  //       for (var item in itemsResponse) {
  //         log("✅ Item: ${item['title']} (ID: ${item['item_id']})");
  //       }
  //     }
  //   } catch (e, stack) {
  //     log("❌ Error fetching user data: $e\n$stack");
  //     throw Exception("Failed to fetch user-related data: $e");
  //   }
  // }
