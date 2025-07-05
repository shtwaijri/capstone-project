// Sends a push notification to specific users identified by their External IDs
// using the OneSignal REST API.
//
// This function constructs an HTTP POST request to the OneSignal /notifications endpoint.
//
// Parameters:
// externalUserId: A [List<String>] containing the external IDs of the users
//   who should receive the notification. Typically, this list contains one ID
//   for a specific user
//  title: The title of the push notification that will be displayed to the user.
// message: The main body text of the push notification.
//
// Throws:
// - An [http.ClientException] or other network-related exceptions if the
//   HTTP request fails for network reasons.

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Future<void> sendNotificationByExternalId({
//   required List<String> externalUserId,
//   required String title,
//   required String message,
// }) async {
//   final url = Uri.parse('https://onesignal.com/api/v1/notifications');

//   final  String appId = dotenv.env['appIDOneSignal'].toString();
//   final String authKey = dotenv.env['AuthorizationoneSignal'].toString();

//    if (appId == null ) {
//     throw Exception('OneSignal credentials are missing in .env');
//   }if ( authKey == null) {
//     throw Exception('OneSignal credentials are missing in .env');
//   }


//   final body = {
//     "app_id": appId,
//     "contents": {"en": message},
//     "headings": {"en": title},
//     "include_aliases": {"external_id": externalUserId},
//     "target_channel": "push",
//     "data": {"key": "1"},
//   };

//   final headers = {
//     'Content-Type': 'application/json; charset=utf-8',
//     'Authorization': authKey,
//   };

//   final response = await http.post(
//     url,
//     headers: headers,
//     body: jsonEncode(body),
//   );

//   if (response.statusCode == 200) {
//     log('✅ Notification sent successfully: ${response.body}');
//   } else {
//     log('❌ Failed to send notification: ${response.statusCode}');
//     log(response.body);
//   }
// }



Future<void> sendNotificationByPlayerId({
  required List<String> playerId,
  required String title,
  required String message,
}) async {
  final url = Uri.parse('https://onesignal.com/api/v1/notifications');

  final body = {
    "app_id": dotenv.env['appIDOneSignal'].toString(),
    "include_player_ids": playerId,
    "headings": {"en": title},
    "contents": {"en": message},
  };

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": dotenv.env['AuthorizationoneSignal'].toString(),
    },
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}