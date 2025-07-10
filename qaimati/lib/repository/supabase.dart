// ignore_for_file: depend_on_referenced_packages, prefer_collection_literals, unused_local_variable

import 'dart:convert';
import 'package:async/async.dart'; // For StreamZip

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConnect {
  static SupabaseClient? supabase;
  static Future<void> init() async {
    try {
      await Supabase.initialize(
        anonKey: dotenv.env['anonKey'].toString(),
        url: dotenv.env['url'].toString(),
        authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      );

      supabase = Supabase.instance.client;
    } catch (e) {
      throw FormatException('error in db initialization: $e');
    }
  }

  static Stream<List<ItemModel>> listenToAllUserItemsDirectly(String userId) {
    if (supabase == null) {
      return Stream.error("Supabase is not initialized.");
    }

    // Stream for items directly linked to the user
    final userItemsStream = supabase!
        .from('item')
        .stream(primaryKey: ['item_id'])
        .eq('app_user_id', userId)
        .map((data) {
          return data
              .map((itemMap) => ItemModelMapper.fromMap(itemMap))
              .toList();
        })
        .handleError((error) {
          return <ItemModel>[];
        });

    // Future to fetch shared list IDs
    final sharedListIdsFuture = supabase!
        .from('list_user_role')
        .select('list_id')
        .eq('app_user_id', userId)
        .then((response) {
          final listIds = response
              .map<String>((row) => row['list_id'] as String)
              .toList();

          return listIds;
        })
        .catchError((error) {
          return <String>[]; // Return empty list on error
        });

    // Stream for shared list items
    final sharedListItemsStream = Stream.fromFuture(sharedListIdsFuture)
        .asyncExpand((listIds) {
          if (listIds.isEmpty) {
            return Stream.value(
              <ItemModel>[],
            ); // Return empty stream if no shared lists
          }

          // Fetch all items and filter manually
          return supabase!
              .from('item')
              .stream(primaryKey: ['item_id'])
              .map((data) {
                final filteredItems = data
                    .where((itemMap) => listIds.contains(itemMap['list']))
                    .toList();

                return filteredItems
                    .map((itemMap) => ItemModelMapper.fromMap(itemMap))
                    .toList();
              })
              .handleError((error) {
                return <ItemModel>[];
              });
        });

    // Combine the two streams and remove duplicates
    return StreamZip([userItemsStream, sharedListItemsStream]).map((streams) {
      final List<ItemModel> userItems = streams[0];
      final List<ItemModel> sharedListItems = streams[1];

      // Combine and remove duplicates based on item_id
      final combinedItems = [
        ...userItems,
        ...sharedListItems,
      ].toSet().toList(); // Use Set to remove duplicates

      return combinedItems;
    });
  }

  // Function to listen to all lists linked to a specific user in real time
  static Stream<List<ListModel>> listenToAllUserListsDirectly(String userId) {
    // Check if the Supabase client is initialized.  If not, return an error stream.

    if (supabase == null) {
      return Stream.error("Supabase is not initialized.");
    }

    return supabase! // Listen to changes in the 'list_user_role' table (user-list relationships).
        .from('list_user_role')
        .stream(primaryKey: ['list_user_role_id'])
        .eq(
          'app_user_id',
          userId,
        ) // Filter rows to only include records for the specified user.
        .asyncMap((data) async {
          // For each update, fetch the related list details asynchronously.
          final List<String> listIds =
              data // Extract the list IDs the user is associated with.
                  .map((row) => row['list_id'] as String)
                  .toList();
          // If no lists are associated, return an empty list.

          if (listIds.isEmpty) {
            return <ListModel>[];
          }

          // Query the 'list' table to get full details of the lists.

          final listsData = await supabase!
              .from('list')
              .select('*')
              .inFilter('list_id', listIds);

          return listsData // Convert the retrieved list data maps into ListModel instances.
              .map((listMap) => ListModelMapper.fromMap(listMap))
              .toList();
        }) // Handle any errors by  returning an empty list.
        .handleError((error) {
          return <ListModel>[];
        });
  }

  static Future<void> sendOtp({required String email}) async {
    try {
      if (supabase == null) {
        throw AuthException("Supabase is not initialized.");
      }

      await supabase!.auth.signInWithOtp(email: email);
    } catch (e) {
      throw AuthException("Failed to send OTP: $e");
    }
  }

  static Future<void> verifyOtp({
    required String email,
    required String token,
  }) async {
    try {
      final response = await supabase!.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
      if (response.user == null) {
        throw AuthException(
          "OTP verification failed. Invalid code or expired.",
        );
      }
    } catch (e) {
      throw AuthException("Failed to verify OTP: $e");
    }
  }

  /// Method to sign out the current user.
  /// It clears the user session and tokens locally.
  /// Throws an exception if an error occurs during the sign-out process.
  Future<void> signOut() async {
    try {
      await supabase!.auth.signOut();
      // Optional: You can add any additional logic here after successful sign out,
      // such as navigating the user to the login screen or clearing local data.
    } on AuthException catch (e) {
      // Handle specific authentication errors during sign out (e.g., network issues).
      throw AuthException('Failed to sign out: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors during sign out.
      throw AuthException('An unexpected error occurred during sign out.');
    }
  }

  static Future<void> updateEmail(String newEmail) async {
    try {
      await supabase!.auth.updateUser(UserAttributes(email: newEmail));
    } catch (e) {
      throw Exception("Failed to update password: $e");
    }
  }

  //method to upser user info

  static Future<void> upsertUserProfile({
    required String userId,

    required String name,
    required String? email,
  }) async {
    try {
      await supabase!.from("app_user").upsert({
        'name': name,
        'email': email,
        'auth_user_id': userId,
      });
    } catch (e) {
      throw Exception('Failed to upsert user profile');
    }
  }

  //add  here deleteUser method

  // Function to update the 'status' field of a specific item in the database
  static Future<void> updateItemStatus({
    required String itemId, // The unique ID of the item to update
    required bool status, // The new status value to set
  }) async {
    try {
      // Perform the update query on the 'item' table where item_id matches
      await SupabaseConnect.supabase!
          .from('item')
          .update({'status': status})
          .eq('item_id', itemId);
    } catch (e) {
      // throw an exception if the update fails
      throw Exception("Failed to update status for item $itemId: $e");
    }
  }

  // Function to get the role name of a specific user for a specific list

  static Future<String?> getUserRoleForCurrentList({
    required String userId, // The ID of the user
    required String listId, // The ID of the list
  }) async {
    try {
      // Query the 'list_user_role' table to get the role name joined from the 'roles' table
      // Select the 'name' field from the related 'roles' table  Filter by user ID &list ID and return  Expect a single record
      final response = await supabase!
          .from('list_user_role')
          .select('roles(name)')
          .eq('app_user_id', userId)
          .eq('list_id', listId)
          .single();

      // Check if a valid response with a role was returned
      // ignore: unnecessary_null_comparison
      if (response != null &&
          response['roles'] != null &&
          response.isNotEmpty) {
        final roleName = response['roles']['name'];
        return roleName;
      } else {
        // No role found for this user in the specified list
        return null;
      }
    } catch (e) {
      // rethrow any errors that occurred during the query
      throw Exception("Error getting role for user:$e");
    }
  }

  static Future<AppUserModel?> getUser(String userId) async {
    try {
      final response = await supabase!
          .from('app_user')
          .select()
          .eq('user_id', userId)
          .single();

      if (response.isEmpty) {
        return null;
      }

      final user = AppUserModelMapper.fromMap(response);
      return user;
    } catch (e) {
      throw Exception(" Error fetching user:$e");
    }
  }

  // Function to fetch a user record from the 'app_user' table using the auth user ID
  static Future<AppUserModel?> getUserFromAuth(String userId) async {
    try {
      // Query the 'app_user' table to get the user where 'auth_user_id' matches
      final response = await supabase!
          .from('app_user')
          .select()
          .eq('auth_user_id', userId)
          .single(); // Expect a single record

      // If no record is found, return null
      if (response.isEmpty) {
        return null;
      }
      // Map the result to an AppUserModel object
      final user = AppUserModelMapper.fromMap(response);
      return user;
    } catch (e) {
      //rethrow any errors that occurred during the query
      throw Exception(" Error fetching user:$e");
    }
  }

  // Function to add a new item to the 'item' table and send a notification to users in the list

  static Future<void> addNewItem({required ItemModel item}) async {
    try {
      // Convert the ItemModel to a map for insertion

      final itemMap = item.toMap();

      if (item.itemId == null) {
        itemMap.remove('item_id');
      }
      // Insert the item into the 'item' table and get the inserted row(s)

      final response = await supabase!.from('item').insert(itemMap).select();

      // Check if any data was returned
      if (response.isNotEmpty) {
        // Convert the inserted row to an ItemModel
        final newItem = ItemModelMapper.fromMap(response.first);

        final listName = (await supabase!
            .from('list_user_role')
            .select('list(name)')
            .eq('list_id', item.listId)
            .single())['list']['name'];

        // Build the notification content
        String notificationTitle = "newitemadded!".tr();
        String notificationMessage =
            "${"itemaddedby".tr()}  ${newItem.title}  ${"inlist:".tr()} $listName.";
        String? excludeUserId = newItem.appUserId;

        // Send a notification to other users in the same list
        await SupabaseConnect.notifyUsersInList(
          newItem.listId,
          notificationTitle,
          notificationMessage,
          excludeUserId,
        );
      }
    } catch (e) {
      // rethrow any errors
      throw Exception('Failed to add new item & send notifcation to users');
    }
  }

  // Function to update an existing item in the 'item' table

  static Future<void> updateItem({
    required ItemModel item,
    required String listName,
  }) async {
    try {
      // Perform the update where the item_id matches
      await supabase!
          .from('item')
          .update(item.toMap())
          .eq('item_id', item.itemId!);

      final String notificationTitle = "${"itemupdated!".tr()}  ${item.title}";
      final String notificationMessage =
          "${"itemupdatedby".tr()} ${item.createdBy}${"inlist:".tr()}+ '$listName'.";
      // Send a notification to other users in the same list
      await SupabaseConnect.notifyUsersInList(
        item.listId,
        notificationTitle,
        notificationMessage,
        item.appUserId,
      );
    } catch (e) {
      // throw any errors
      throw Exception("Failed to update item in Supabase: $e");
    }
  }

  // Function to delete an item from the 'item' table

  static Future<void> deleteItem({required ItemModel item}) async {
    try {
      // Perform the delete operation where the item_id matches
      await supabase!.from('item').delete().eq('item_id', item.itemId!);
    } catch (e) {
      // throw any errors

      throw Exception("Failed to update item in Supabase: $e");
    }
  }

  // Function to update multiple items, setting 'is_completed' to true and updating 'closed_at' timestamp

  static Future<void> updateItemsIsCompletedToTurue({
    required List<String> itemIds, // List of item IDs to update
  }) async {
    try {
      // Return early if the list is empty

      if (itemIds.isEmpty) {
        return;
      }

      // Prepare the fields to update
      final Map<String, dynamic> updates = {
        'is_completed': true,
        'closed_at': DateTime.now().toIso8601String(),
      };
      // Perform the batch update on items whose IDs are in the provided list
      await supabase!
          .from('item')
          .update(updates)
          .filter('item_id', 'in', itemIds);

      await Future.delayed(Duration(milliseconds: 400));
    } catch (e) {
      //throw exceptions if update fails

      throw Exception(
        "Failed to update isCompleted/closed_at for items in Supabase: $e",
      );
    }
  }

  // Function to send a notification via OneSignal using external user IDs
  static Future<void> sendNotificationByExternalId({
    required List<String>
    externalUserIds, // List of OneSignal external user IDs to notify
    required String title, // Notification title
    required String message, // Notification message
  }) async {
    final url = Uri.parse(
      'https://onesignal.com/api/v1/notifications',
    ); // Build the request URL
    // Build the request body
    final body = {
      "app_id": dotenv.env['appIDOneSignal'].toString(),
      "include_external_user_ids": externalUserIds,
      "headings": {"en": title},
      "contents": {"en": message},
    };

    try {
      // Make the POST request to OneSignal API
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": dotenv.env['AuthorizationoneSignal'].toString(),
        },
        body: json.encode(body),
      );
      // Handle the response
    } catch (e) {
      //throw exceptions if notification fails
      throw Exception('Error sending notification: $e');
    }
  }

  // Function to notify all users in a given list
  static Future<void> notifyUsersInList(
    String listId, // The ID of the list to notify users in
    String notificationTitle, // Notification title
    String notificationMessage, // Notification message body
    String? excludeUserId, // Optional: user ID to exclude from notification
  ) async {
    try {
      // 1. Fetch all users in the list
      final List<AppUserModel> usersToNotify = await getUsersInList(listId);
      //if no user to notify return back
      if (usersToNotify.isEmpty) {
        return;
      }

      // Prepare lists for notification payload and DB records
      List<String> externalUserIds = [];
      List<Map<String, dynamic>> notificationsToInsert = [];

      for (var user in usersToNotify) {
        externalUserIds.add(user.userId); // Collect OneSignal external user IDs

        // for (var user in usersToNotify) {
        //     // Exclude the specified user if needed
        //     if (excludeUserId != null && user.userId == excludeUserId) {
        //       continue;
        //     }

        // Prepare notification record for Supabase
        notificationsToInsert.add({
          'app_user_id': user.userId,
          'title': notificationTitle,
          'body': notificationMessage,
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      // if No  users found, no notifications to send or save.
      if (externalUserIds.isEmpty && notificationsToInsert.isEmpty) {
        return;
      }

      // 2. Save notification records in Supabase
      if (notificationsToInsert.isNotEmpty) {
        await supabase!
            .from('notification')
            .insert(notificationsToInsert)
            .select();
      }

      if (externalUserIds.isNotEmpty) {
        // 3. Send push notification via OneSignal
        await sendNotificationByExternalId(
          externalUserIds: externalUserIds,
          title: notificationTitle,
          message: notificationMessage,
        );
      }
    } catch (_) {}
  }

  // Function to get all users in a given list

  static Future<List<AppUserModel>> getUsersInList(String listId) async {
    try {
      // 1. Get user IDs and their roles from the list_user_role table
      final response = await supabase!
          .from('list_user_role')
          .select('app_user_id, roles(name)')
          .eq('list_id', listId);
      // if No users found return
      if (response.isEmpty) {
        return [];
      }

      // Extract user IDs and roles
      List<String> userIds = [];
      Map<String, String> userRoles = {};
      for (var item in response) {
        final userId = item['app_user_id'];
        final role = item['roles']['name'];
        if (userId != null) {
          userIds.add(userId as String);
          userRoles[userId] = role as String;
        }
      }

      // 2. Fetch user details from app_user table
      final usersResponse = await supabase!
          .from('app_user')
          .select('*')
          .inFilter('user_id', userIds);

      List<AppUserModel> users = []; //list of uers
      //if there is usere from Response save it as AppUserModel
      if (usersResponse.isNotEmpty) {
        users = usersResponse.map((e) {
          final user = AppUserModelMapper.fromMap(e);

          return user;
        }).toList();
      }
      return users; //return uses
    } catch (e) {
      throw Exception(
        "Failed to fetch users for list: $e",
      ); //throw exceptions if update fails
    }
  }

  // ==================================================== Start get role name ===============================================
  static Future<String> getRoleIdByName(String roleName) async {
    // will used when get lest to check role
    final result = await supabase!
        .from('roles')
        .select('roles_id')
        .eq('name', roleName)
        .maybeSingle();

    if (result == null) {
      throw Exception('❌ Role "$roleName" not found.');
    }

    return result['roles_id'] as String;
  }

  // ==================================================== End get role name ==================================================
  // ================================================== Start getAdminLists ================================================
  static Future<List<ListModel>> getAdminLists() async {
    try {
      // to get current user
      final appUser = await fetchUserById();
      if (appUser == null) {
        throw Exception("❌ Failed to fetch current user");
      }
      final appUserId = appUser.userId;

      // get admin role
      final adminRoleId = await getRoleIdByName('admin');

      // get admin lists
      final roleRows = await supabase!
          .from('list_user_role')
          .select('list_id')
          .eq('app_user_id', appUserId)
          .eq('role_id', adminRoleId);

      if (roleRows.isEmpty) {
        return [];
      }

      final listIds = roleRows
          .map<String>((row) => row['list_id'] as String)
          .toList();

      // get list details
      final listRows = await supabase!
          .from('list')
          .select()
          .inFilter('list_id', listIds);
      final lists = listRows
          .map<ListModel>((row) => ListModelMapper.fromMap(row))
          .toList();

      return lists;
    } catch (e) {
      throw Exception("Failed to fetch admin lists: $e");
    }
  }

  // ================================================== End getAdminLists =================================================

  // ================================================== Start getmemberLists ==============================================

  //THIS BY AMR

  //   static Future<List<ListModel>> getMemberLists() async {
  //   try {
  //     log("📥 Fetching member lists");

  //     // Get current user
  //     final appUser = await fetchUserById();
  //     if (appUser == null) {
  //       throw Exception("❌ Failed to fetch current user");
  //     }
  //     final appUserId = appUser.userId;

  //     // Get role_id for 'member'
  //     final memberRoleId = await getRoleIdByName('admin'); // need to conver to member

  //     // Query list_user_role where user is a member
  //     final roleRows = await supabase!
  //         .from('list_user_role')
  //         .select('list_id')
  //         .eq('app_user_id', appUserId)
  //         .eq('role_id', memberRoleId);

  //     if (roleRows.isEmpty) {
  //       log("🔍 No member lists found for user $appUserId");
  //       return [];
  //     }

  //     // Extract list_ids
  //     final listIds = roleRows.map<String>((row) => row['list_id'] as String).toList();

  //     // Fetch list data
  //     final listRows = await supabase!
  //         .from('list')
  //         .select()
  //         .inFilter('list_id', listIds);

  //     final lists = listRows
  //         .map<ListModel>((row) => ListModelMapper.fromMap(row))
  //         .toList();

  //     log("✅ Fetched ${lists.length} member lists for user $appUserId");

  //     return lists;
  //   } catch (e, stack) {
  //     log("❌ Error in getMemberLists: $e\n$stack");
  //     throw Exception("Failed to fetch member lists: $e");
  //   }
  // }

  //SAME METHOD WITH SIMPLE ADDITION BY SHATHA
  static Future<List<ListModel>> getMemberLists() async {
    try {
      // Get current user
      final appUser = await fetchUserById();
      if (appUser == null) {
        throw Exception("❌ Failed to fetch current user");
      }
      final appUserId = appUser.userId;

      // Get role_id for 'member'
      final memberRoleId = await getRoleIdByName(
        'member',
      ); // 🔄 Edited by Shatha: changed from 'admin' to 'member'

      // Query list_user_role where user is a member
      final roleRows = await supabase!
          .from('list_user_role')
          .select('list_id')
          .eq('app_user_id', appUserId)
          .eq('role_id', memberRoleId);

      if (roleRows.isEmpty) {
        return [];
      }

      // Extract list_ids
      final listIds = roleRows
          .map<String>((row) => row['list_id'] as String)
          .toList();

      // Fetch list data
      final listRows = await supabase!
          .from('list')
          .select()
          .inFilter('list_id', listIds);

      final lists = listRows
          .map<ListModel>((row) => ListModelMapper.fromMap(row))
          .toList();

      return lists;
    } catch (e) {
      throw Exception("Failed to fetch member lists: $e");
    }
  }

  // ================================================== End getmemberLists ================================================

  // ================================================== Start addNewList ==================================================
  static Future<ListModel?> addNewList({required ListModel list}) async {
    try {
      final listMap = list.toMap();

      if (list.listId.isEmpty) {
        listMap.remove('list_id'); // Remove list if list_id is null or empty
      }

      // Get current user
      final appUser = await fetchUserById();
      if (appUser == null) {
        throw Exception('❌ Failed to get current user');
      }
      final appUserId = appUser.userId;

      // Get role_id for 'admin'
      final adminRoleId = await getRoleIdByName('admin');

      // Add new list
      final response = await supabase!.from('list').insert(listMap).select();

      if (response.isEmpty) {
        throw Exception('❌ Failed to insert new list.');
      }

      final newList = ListModelMapper.fromMap(response.first);

      // Link user to list as admin
      final listUserRoleMap = {
        'app_user_id': appUserId,
        'role_id': adminRoleId,
        'list_id': newList.listId,
        'assigned_at': DateTime.now().toIso8601String(),
      };

      await supabase!.from('list_user_role').insert(listUserRoleMap);

      return newList;
    } catch (e) {
      throw Exception('Failed to add new list and assign admin role.');
    }
  }

  // ================================================== End addNewList ==================================================

  // ================================================== Start editList ==================================================
  static Future<void> updateList({required ListModel list}) async {
    try {
      // Get current user
      final appUser = await fetchUserById();
      if (appUser == null) {
        throw Exception('❌ Failed to get current user');
      }
      final appUserId = appUser.userId;

      // Get role_id for 'admin'
      final adminRoleId = await getRoleIdByName('admin');

      // Check if user is admin
      final roleCheck = await supabase!
          .from('list_user_role')
          .select()
          .eq('app_user_id', appUserId)
          .eq('list_id', list.listId)
          .eq('role_id', adminRoleId)
          .maybeSingle();

      if (roleCheck == null) {
        throw Exception('⛔ User is not admin of this list. Update denied.');
      }

      // Update list
      final updateData = {'name': list.name, 'color': list.color};

      await supabase!
          .from('list')
          .update(updateData)
          .eq('list_id', list.listId);
    } catch (e) {
      throw Exception("Failed to update list: $e");
    }
  }

  // =================================================== End editList ===================================================
  static Future<void> deleteList({required String listId}) async {
    try {
      // Get current user
      final appUser = await fetchUserById();
      if (appUser == null) {
        throw Exception("❌ Failed to fetch current user");
      }
      final appUserId = appUser.userId;

      // Get role_id for 'admin'
      final adminRoleId = await getRoleIdByName('admin');

      // Check if user is admin of this list
      final roleCheck = await supabase!
          .from('list_user_role')
          .select()
          .eq('app_user_id', appUserId)
          .eq('list_id', listId)
          .eq('role_id', adminRoleId)
          .maybeSingle();

      if (roleCheck == null) {
        throw Exception('⛔ User is not admin of this list. Deletion denied.');
      }

      // 🔥 Delete all rows in list_user_role that reference this list
      await supabase!.from('list_user_role').delete().eq('list_id', listId);

      // 🔥 Now delete the list itself
      await supabase!.from('list').delete().eq('list_id', listId);
    } catch (e) {
      throw Exception("Failed to delete list: $e");
    }
  }

  // ================================================== End deleteList ====================================================
}
