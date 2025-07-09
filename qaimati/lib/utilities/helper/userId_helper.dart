// ignore_for_file: file_names, await_only_futures

import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';

///method to fetch user id from shared prefernce method
//used for non auth related (like Theme, Language)
Future<String?> fetchUserId() async {
  final userID = await GetIt.I.get<AuthLayer>().getUserId();
  if (userID == null) {
    throw Exception('User Id not found in shared pref');
  }
  return userID;
}

/// Fetches currently logged-in user's id from Supabase session.
/// Used for authentication and user-related queries.
String? fetchUserIdFromSupabase() {
  final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();
  if (userId == null) {
    throw Exception('User not logged in');
  }
  return userId;
}

Future<AppUserModel?> fetchUserById() async {
  try {
    final String? id = await fetchUserIdFromSupabase();

    if (id == null) {
      throw FormatException("Auth id is null please refresh page");
    }

    AppUserModel? user = await GetIt.I.get<AuthLayer>().getUserObj(userId: id);
    if (user != null && user.userId.isNotEmpty) {
      return user;
    }

    return null;
  } catch (e) {
    throw Exception(e);
  }
}
