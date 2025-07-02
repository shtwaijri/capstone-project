//methodd to fetch user id
import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/auth_layer.dart';

Future<String?> fetchUserId() async {
  final userID = await GetIt.I.get<AuthLayer>().getUserId();
  if (userID == null) {
    throw Exception('User Id not found in shared pref');
  }
  return userID;
}
