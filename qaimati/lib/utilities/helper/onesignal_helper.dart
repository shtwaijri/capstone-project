 
//import 'package:http/http.dart' as http;



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

import 'package:http/http.dart' as http;

Future<void> sendNotificationByExternalId({
  required List<String> externalUserId,
  required String title,
  required String message,
}) async {
  final url = Uri.parse('');
  final body = {
    "app_id": "",
    "contents": {"en": message},
    "headings": {"en": title},
    "include_aliases": {"external_id": externalUserId},
    "target_channel": "push",
    "data": {"key": "1"},
  };
  final headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization':""
       ,
  };
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );
  if (response.statusCode == 200) {
    log('Notification sent successfully: ${response.body}');
  } else {
    log('Failed to send notification: ${response.statusCode}');
    log(response.body);
  }
}





