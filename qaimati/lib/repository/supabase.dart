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

  static Stream<List<ItemModel>> listenToAllUserItemsDirectly(String userId) {
    if (supabase == null) {
      log("Supabase is not initialized when trying to listen to user items.");
      return Stream.error("Supabase is not initialized.");
    }
    log(
      "SupabaseConnect: Setting up realtime listener for all items directly linked to user: $userId",
    );
    return supabase!
        .from('item')
        .stream(primaryKey: ['item_id'])
        .map((data) {
          return data
              .map((itemMap) => ItemModelMapper.fromMap(itemMap))
              .toList();
        })
        .handleError((error) {
          log("SupabaseConnect: Error in all user items stream: $error");
          return <ItemModel>[];
        });
  }

  static Stream<List<ListModel>> listenToAllUserListsDirectly(String userId) {
    if (supabase == null) {
      log("Supabase is not initialized when trying to listen to user lists.");
      return Stream.error("Supabase is not initialized.");
    }
    log(
      "SupabaseConnect: Setting up realtime listener for all lists directly linked to user: $userId",
    );

    return supabase!
        .from('list_user_role')
        .stream(primaryKey: ['list_user_role_id'])
        .eq('app_user_id', userId)
        .asyncMap((data) async {
          final List<String> listIds = data
              .map((row) => row['list_id'] as String)
              .toList();

          if (listIds.isEmpty) {
            return <ListModel>[];
          }

          final listsData = await supabase!
              .from('list')
              .select('*')
              .inFilter('list_id', listIds);

          return listsData
              .map((listMap) => ListModelMapper.fromMap(listMap))
              .toList();
        })
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
      throw Exception("Failed to update status for item $itemId: $e");
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

  static Future<AppUserModel?> getUserFromAuth(String userId) async {
    try {
      log("getUserFromAuth📥 Fetching user from Supabase: $userId");

      final response = await supabase!
          .from('app_user')
          .select()
          .eq('auth_user_id', userId)
          .single();

      if (response.isEmpty) {
        log("getUserFromAuth 🚫 No user found with ID: $userId");
        return null;
      }

      final user = AppUserModelMapper.fromMap(response);
      log("✅ User fetched: ${user.name}   ${user.userId}");
      return user;
    } catch (e, stack) {
      log("❌ Error fetching user: $e\n$stack");
      throw Exception(" Error fetching user:$e");
    }
  }

  static Future<ItemModel?> addNewItem({required ItemModel item}) async {
    try {
      log("start addNewItem");

      final itemMap = item.toMap();

      if (item.itemId == null) {
        itemMap.remove('item_id');
      }

      final response = await supabase!.from('item').insert(itemMap).select();

      if (response.isNotEmpty) {
        log("response addNewItem isNotEmpty");
        final newItem = ItemModelMapper.fromMap(response.first);
        log("newItem ${newItem.toString()}");
        log("response addNewItem ItemModelMapper correct ");

        String notificationTitle = "newitemadded!".tr();
        String notificationMessage =
            "${"item added by".tr()}  ${newItem.title}  ${"inlist:".tr()} ${newItem.listId}.";
        String? excludeUserId = newItem.appUserId;

        await SupabaseConnect.notifyUsersInList(
          newItem.listId,
          notificationTitle,
          notificationMessage,
          excludeUserId,
        );

        return newItem;
      }
    } catch (e, stack) {
      log('❌ Error inserting item: $e\n$stack');
      throw Exception('Failed to add new item & send notifcation to users');
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
      await supabase!.from('item').delete().eq('item_id', item.itemId!);

      log("✅ SupabaseConnect: Item ${item.itemId} updated successfully in DB.");
    } catch (e, stack) {
      log(
        "❌ SupabaseConnect: Failed to update item ${item.itemId} in DB: $e\n$stack",
      );
      throw Exception("Failed to update item in Supabase: $e");
    }
  }

  static Future<void> updateItemsIsCompletedToTurue({
    required List<String> itemIds,
  }) async {
    try {
      if (itemIds.isEmpty) {
        return;
      }

      final Map<String, dynamic> updates = {
        'is_completed': true,
        'closed_at': DateTime.now().toIso8601String(),
      };

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
      throw Exception(
        "Failed to update isCompleted/closed_at for items in Supabase: $e",
      );
    }
  }

  // static Future<void> notifyUsersInList(
  //   String listId,
  //   String notificationTitle,
  //   String notificationMessage,
  //   String? excludeUserId,
  // ) async {
  //   try {
  //     log("🔔 Attempting to notify all users in list: $listId");

  //     final List<AppUserModel> usersToNotify = await getUsersInList(listId);

  //     if (usersToNotify.isEmpty) {
  //       log("🚫 No users found to notify in list: $listId");
  //       return;
  //     }

  //     List<String> externalUserIds = [];
  //     List<Map<String, dynamic>> notificationsToInsert = [];
  //     for (var user in usersToNotify) {
  //       //          externalUserIds.add(user.userId);

  //       //if (user.userId != excludeUserId) {
  //       externalUserIds.add(user.userId);
  //       //  }

  //       notificationsToInsert.add({
  //         'app_user_id': user.userId,
  //         'title': notificationTitle,
  //         'body': notificationMessage,
  //         'is_read': true,
  //         'created_at': DateTime.now().toIso8601String(),
  //       });
  //     }

  //     if (externalUserIds.isEmpty && notificationsToInsert.isEmpty) {
  //       log("🚫 No eligible users found, no notifications to send or save.");
  //       return;
  //     }

      
  //       log(
  //         "💾 Saving ${notificationsToInsert.length} notification records to Supabase for list $listId.",
  //       );
  //       await supabase!
  //           .from('notification')
  //           .insert(notificationsToInsert)
  //           .select();
  //       log("✅ Notification records saved to Supabase for list $listId.");
      

  //     // if (externalUserIds.isNotEmpty) {
  //     //   log(
  //     //     "📧 Sending push notification to ${externalUserIds.length} users in list $listId.",
  //     //   );
  //       await sendNotificationByExternalId(
  //         externalUserIds: externalUserIds,
  //         title: notificationTitle,
  //         message: notificationMessage,
  //       );
  //       log("✅ Push notifications sent successfully for list $listId.");
  //     // } else {
  //     //   log("⚠️ No external user IDs to send push notifications to.");
  //     // }
  //   } catch (e, stack) {
  //     log("❌ Error notifying users in list $listId: $e\n$stack");
  //     throw FormatException(" Error notifying users in list $e");
  //   }
  // }

  // static Future<List<AppUserModel>> getUsersInList(String listId) async {
  //   try {
  //     log("🔄 Fetching users for list: $listId");

  //     final response = await supabase!
  //         .from('list_user_role')
  //         .select('app_user_id, roles(name)')
  //         .eq('list_id', listId);
  //         log("start geting users in list");
  //      for (var element in response) {
  //       log(element.entries.toString());
         
  //      }
  //        log("end");
  //     if (response.isEmpty) {
  //       log("🚫 No users found for list: $listId");
  //       return [];
  //     }

  //     List<String> userIds = [];
  //     Map<String, String> userRoles = {};
  //     for (var item in response) {
  //       final userId = item['app_user_id'];
  //       final role = item['roles']['name'];
  //       if (userId != null) {
  //         userIds.add(userId as String);
  //         userRoles[userId] = role as String;
  //       }
  //     }

  //     final usersResponse = await supabase!
  //         .from('app_user')
  //         .select('*')
  //         .inFilter('user_id', userIds);

  //     List<AppUserModel> users = [];
  //     if (usersResponse.isNotEmpty) {
  //       users = usersResponse.map((e) {
  //         final user = AppUserModelMapper.fromMap(e);
  //         log(
  //           "👤 User: ${user.name} (ID: ${user.userId}, Role: ${userRoles[user.userId]})",
  //         );
  //         return user;
  //       }).toList();
  //     }
  //     return users;
  //   } catch (e, stack) {
  //     log("❌ Error fetching users for list $listId: $e\n$stack");
  //     throw Exception("Failed to fetch users for list: $e");
  //   }
  // }
//   static Future<List<AppUserModel>> getUsersInList(String listId) async {
//   try {
//   log("🔄 Fetching users for list: $listId");

//  final response = await supabase!
//  .from('list_user_role')
//  .select('app_user_id, roles(name)')
//   .eq('list_id', listId);
//  log("start geting users in list");
//  for (var element in response) {
//   log(element.entries.toString());
 
//  }
//  log("end");
//   if (response.isEmpty) {
//   log("🚫 No users found for list: $listId");
//   return [];
//   }

//   List<String> userIds = [];
//    Map<String, String> userRoles = {};
//   for (var item in response) {
//  final userId = item['app_user_id'];
//  final role = item['roles']['name']; // THIS LINE
//  if (userId != null) {
//  userIds.add(userId as String);
//   userRoles[userId] = role as String;
//   }
//   }

//  final usersResponse = await supabase!
//  .from('app_user')
//  .select('*')
// .inFilter('user_id', userIds);

//   List<AppUserModel> users = [];
//  if (usersResponse.isNotEmpty) {
//  users = usersResponse.map((e) {
//  final user = AppUserModelMapper.fromMap(e);
//   log(
//  "👤 User: ${user.name} (ID: ${user.userId}, Role: ${userRoles[user.userId]})",
//  );
//   return user;
//  }).toList();
//   }
//   return users;
//  } catch (e, stack) {
//  log("❌ Error fetching users for list $listId: $e\n$stack");
//  throw Exception("Failed to fetch users for list: $e");
//   }
//   }

  static Future<void> sendNotificationByExternalId({
    required List<String> externalUserIds,
    required String title,
    required String message,
  }) async {
    final url = Uri.parse('https://onesignal.com/api/v1/notifications');

    final body = {
      "app_id": dotenv.env['appIDOneSignal'].toString(),
      "include_external_user_ids": externalUserIds,
      "headings": {"en": title},
      "contents": {"en": message},
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Authorization": dotenv.env['AuthorizationoneSignal'].toString(),
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully: ${response.body}');
      } else {
        print(
          'Failed to send notification: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }




  

static Future<void> notifyUsersInList(
  String listId,
  String notificationTitle,
  String notificationMessage,
  String? excludeUserId, // هذا المتغير لم يعد يستخدم للاستثناء في هذه النسخة
) async {
  try {
    log("🔔 Attempting to notify all users in list: $listId");

    final List<AppUserModel> usersToNotify = await getUsersInList(listId);

    if (usersToNotify.isEmpty) {
      log("🚫 No users found to notify in list: $listId");
      return;
    }

    List<String> externalUserIds = [];
    List<Map<String, dynamic>> notificationsToInsert = [];

    for (var user in usersToNotify) {
      // هنا نقوم بإضافة جميع المستخدمين إلى قائمة externalUserIds
      // بما في ذلك المستخدم الذي قام بالإجراء (إذا كان excludeUserId هو نفسه userId)
      externalUserIds.add(user.userId);

      // إعداد بيانات الإشعار للحفظ في جدول 'notification' في Supabase
      notificationsToInsert.add({
        'app_user_id': user.userId, // معرف المستخدم المستلم
        'title': notificationTitle,
        'body': notificationMessage,
        'is_read': false, // الإشعار غير مقروء عند الإضافة
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    if (externalUserIds.isEmpty && notificationsToInsert.isEmpty) {
      log("🚫 No eligible users found, no notifications to send or save.");
      return;
    }

    // 1. حفظ سجلات الإشعارات في جدول 'notification' في Supabase
    if (notificationsToInsert.isNotEmpty) {
      log("💾 Saving ${notificationsToInsert.length} notification records to Supabase for list $listId.");
      await supabase!
          .from('notification')
          .insert(notificationsToInsert)
          .select();
      log("✅ Notification records saved to Supabase for list $listId.");
    }

    // 2. إرسال الإشعار الفعلي عبر OneSignal
    if (externalUserIds.isNotEmpty) {
      log("📧 Sending push notification to ${externalUserIds.length} users in list $listId.");
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
    // يمكنك هنا إضافة معالجة أخطاء إضافية أو rethrow;
  }
}
  static Future<List<AppUserModel>> getUsersInList(String listId) async {
    try {
      log("🔄 Fetching users for list: $listId");

      final response = await supabase!
          .from('list_user_role')
          .select('app_user_id, roles(name)')
          .eq('list_id', listId);

      if (response.isEmpty) {
        log("🚫 No users found for list: $listId");
        return [];
      }

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

      final usersResponse = await supabase!
          .from('app_user')
          .select('*')
          .inFilter('user_id', userIds);

      List<AppUserModel> users = [];
      if (usersResponse.isNotEmpty) {
        users = usersResponse.map((e) {
          final user = AppUserModelMapper.fromMap(e);
          log(
            "👤 User: ${user.name} (ID: ${user.userId}, Role: ${userRoles[user.userId]})",
          );
          return user;
        }).toList();
      }
      return users;
    } catch (e, stack) {
      log("❌ Error fetching users for list $listId: $e\n$stack");
      throw Exception("Failed to fetch users for list: $e");
    }}
 
}
