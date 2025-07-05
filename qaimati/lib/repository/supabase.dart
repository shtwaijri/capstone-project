import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
        authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      );

      supabase = Supabase.instance.client;

      log('end Supabase init');
      log('supabase client: $supabase');
    } catch (e) {
      log('Error in Supabase init: $e');
      throw FormatException('error in db initialization: $e');
    }
  }

  // Function to listen to all items directly linked to a user in real time
  static Stream<List<ItemModel>> listenToAllUserItemsDirectly(String userId) {
    // Check if Supabase client is initialized. If not, return an error stream.

    if (supabase == null) {
      log("Supabase is not initialized when trying to listen to user items.");
      return Stream.error("Supabase is not initialized.");
    }
    log(
      "SupabaseConnect: Setting up realtime listener for all items directly linked to user: $userId",
    );

    // Set up a realtime stream on the 'item' table using 'item_id' as the primary key.
    return supabase!
        .from('item')
        .stream(primaryKey: ['item_id'])
        .map((data) {
          return data
              // Map each received record (as Map) to an ItemModel object.
              .map((itemMap) => ItemModelMapper.fromMap(itemMap))
              .toList();
        })
        .handleError((error) {
          // Handle any errors in the stream by  returning an empty list.
          log("SupabaseConnect: Error in all user items stream: $error");
          return <ItemModel>[];
        });
  }

  // Function to listen to all lists linked to a specific user in real time
  static Stream<List<ListModel>> listenToAllUserListsDirectly(String userId) {
    // Check if the Supabase client is initialized.  If not, return an error stream.

    if (supabase == null) {
      log("Supabase is not initialized when trying to listen to user lists.");
      return Stream.error("Supabase is not initialized.");
    }
    log(
      "SupabaseConnect: Setting up realtime listener for all lists directly linked to user: $userId",
    );

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
          log("SupabaseConnect: Error in all user lists stream: $error");
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
      log('User signed out successfully.');
    } on AuthException catch (e) {
      // Handle specific authentication errors during sign out (e.g., network issues).
      log('Error during sign out: ${e.message}');
      throw AuthException('Failed to sign out: ${e.message}');
    } catch (e) {
      // Handle any other unexpected errors during sign out.
      log('An unexpected error occurred during sign out: $e');
      throw AuthException('An unexpected error occurred during sign out.');
    }
  }

  static Future<void> updateEmail(String newEmail) async {
    try {
      log("updateEmail subabase start ");
      await supabase!.auth.updateUser(UserAttributes(email: newEmail));
      log("updateEmail subabase end  ");
    } catch (e) {
      log("updateEmail  error $e");

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
      log("✅ Updated item $itemId status to $status");
    } catch (e) {
      // throw an exception if the update fails
      log("❌ Failed to update status for item $itemId: $e");
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
      if (response != null &&
          response['roles'] != null &&
          response.isNotEmpty) {
        final roleName = response['roles']['name'];
        log("🎯 Role for user in list: $roleName");
        return roleName;
      } else {
        // No role found for this user in the specified list
        log("❌ No role found for this user in the list");
        return null;
      }
    } catch (e) {
      // rethrow any errors that occurred during the query
      log("🚨 Error getting role for user: $e");
      throw Exception("Error getting role for user:$e");
    }
  }

  static Future<AppUserModel?> getUser(String userId) async {
    try {
      log("📥 Fetching user from Supabase: $userId");

      final response = await supabase!
          .from('app_user')
          .select()
          .eq('user_id', userId)
          .single();

      if (response.isEmpty) {
        log("🚫 No user found with ID: $userId");
        return null;
      }

      final user = AppUserModelMapper.fromMap(response);
      log("✅ User fetched: ${user.name}");
      return user;
    } catch (e, stack) {
      log("❌ Error fetching user: $e\n$stack");
      throw Exception(" Error fetching user:$e");
    }
  }

  // Function to fetch a user record from the 'app_user' table using the auth user ID
  static Future<AppUserModel?> getUserFromAuth(String userId) async {
    try {
      log("getUserFromAuth📥 Fetching user from Supabase: $userId");
      // Query the 'app_user' table to get the user where 'auth_user_id' matches
      final response = await supabase!
          .from('app_user')
          .select()
          .eq('auth_user_id', userId)
          .single(); // Expect a single record

      // If no record is found, return null
      if (response.isEmpty) {
        log("getUserFromAuth 🚫 No user found with ID: $userId");
        return null;
      }
      // Map the result to an AppUserModel object
      final user = AppUserModelMapper.fromMap(response);
      log("✅ User fetched: ${user.name}   ${user.userId}");
      return user;
    } catch (e, stack) {
      //rethrow any errors that occurred during the query
      log("❌ Error fetching user: $e\n$stack");
      throw Exception(" Error fetching user:$e");
    }
  }

  // Function to add a new item to the 'item' table and send a notification to users in the list

  static Future<void> addNewItem({required ItemModel item}) async {
    try {
      log("start addNewItem");
      // Convert the ItemModel to a map for insertion

      final itemMap = item.toMap();

      if (item.itemId == null) {
        itemMap.remove('item_id');
      }
      // Insert the item into the 'item' table and get the inserted row(s)

      final response = await supabase!.from('item').insert(itemMap).select();

      // Check if any data was returned
      if (response.isNotEmpty) {
        log("response addNewItem isNotEmpty");
        // Convert the inserted row to an ItemModel
        final newItem = ItemModelMapper.fromMap(response.first);
        log("newItem ${newItem.toString()}");
        log("response addNewItem ItemModelMapper correct ");

        // Build the notification content
        String notificationTitle = "newitemadded!".tr();
        String notificationMessage =
            "${"itemaddedby".tr()}  ${newItem.title}  ${"inlist:".tr()} ${newItem.listId}.";
        String? excludeUserId = newItem.appUserId;

        // Send a notification to other users in the same list
        await SupabaseConnect.notifyUsersInList(
          newItem.listId,
          notificationTitle,
          notificationMessage,
          excludeUserId,
        );

      }
    } catch (e, stack) {
      log('❌ Error inserting item: $e\n$stack');
      // rethrow any errors
      throw Exception('Failed to add new item & send notifcation to users');
    }
    // Return null if no item was created
    return null;
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

      log("✅ SupabaseConnect: Item ${item.itemId} updated successfully in DB.");
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
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update item ${item.itemId} in DB: $e\n$stack",
      );
      // throw any errors
      throw Exception("Failed to update item in Supabase: $e");
    }
  }

  // Function to delete an item from the 'item' table

  static Future<void> deleteItem({required ItemModel item}) async {
    try {
      // Perform the delete operation where the item_id matches
      await supabase!.from('item').delete().eq('item_id', item.itemId!);

      log(
        "✅ SupabaseConnect: Item ${item.itemId} deleted successfully from DB.",
      );
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update item ${item.itemId} in DB: $e\n$stack",
      );
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

      log(
        "✅ SupabaseConnect: Successfully updated isCompleted/closed_at for ${itemIds.length} items.",
      );
      await Future.delayed(Duration(milliseconds: 400));
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update isCompleted/closed_at for items: $e\n$stack",
      );
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
      if (response.statusCode == 200) {
        print('Notification sent successfully: ${response.body}');
      } else {
        print(
          'Failed to send notification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log('Error sending notification: $e');
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
      log("🔔 Attempting to notify all users in list: $listId");

      // 1. Fetch all users in the list
      final List<AppUserModel> usersToNotify = await getUsersInList(listId);
      //if no user to notify return back
      if (usersToNotify.isEmpty) {
        log("🚫 No users found to notify in list: $listId");
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
        log("🚫 No eligible users found, no notifications to send or save.");
        return;
      }

      // 2. Save notification records in Supabase
      if (notificationsToInsert.isNotEmpty) {
        log(
          "💾 Saving ${notificationsToInsert.length} notification records to Supabase for list $listId.",
        );
        await supabase!
            .from('notification')
            .insert(notificationsToInsert)
            .select();
        log("✅ Notification records saved to Supabase for list $listId.");
      }

      if (externalUserIds.isNotEmpty) {
        log(
          "📧 Sending push notification to ${externalUserIds.length} users in list $listId.",
        );
        // 3. Send push notification via OneSignal
        await sendNotificationByExternalId(
          externalUserIds: externalUserIds,
          title: notificationTitle,
          message: notificationMessage,
        );
        log("✅ Push notifications sent successfully for list $listId.");
      } else {
        log("⚠️ No external user IDs to send push notifications to.");
      }
    } catch (e, stack) {
      log("❌ Error notifying users in list $listId: $e\n$stack");
    }
  }

  // Function to get all users in a given list

  static Future<List<AppUserModel>> getUsersInList(String listId) async {
    try {
      log("🔄 Fetching users for list: $listId");
      // 1. Get user IDs and their roles from the list_user_role table
      final response = await supabase!
          .from('list_user_role')
          .select('app_user_id, roles(name)')
          .eq('list_id', listId);
      // if No users found return
      if (response.isEmpty) {
        log("🚫 No users found for list: $listId");
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
          log(
            "👤 User: ${user.name} (ID: ${user.userId}, Role: ${userRoles[user.userId]})",
          );
          return user;
        }).toList();
      }
      return users; //return uses
    } catch (e, stack) {
      log("❌ Error fetching users for list $listId: $e\n$stack");
      throw Exception(
        "Failed to fetch users for list: $e",
      ); //throw exceptions if update fails
    }
  }
}
