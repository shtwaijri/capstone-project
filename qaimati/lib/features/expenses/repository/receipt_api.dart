import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:qaimati/features/expenses/model/receipt_api_model.dart';

/// This class handles sending receipt images to the Mindee API
/// and parsing the returned data into a [ReceiptApiModel].
class ReceiptApi {
  // Base URL for the Mindee API
  static const String _baseURL = 'https://api.mindee.net';
  // Specific endpoint for analyzing expense receipts
  static const String _receiptEndpoint =
      '/v1/products/mindee/expense_receipts/v5/predict';
  // API Key loaded from the environment (.env)
  final String _apiKey = dotenv.env['apikey'].toString();

  /// Sends the provided [image] to the Mindee API for receipt analysis.
  ///
  /// It converts the image to base64, sends a POST request,
  /// then parses the response into a [ReceiptApiModel].
  ///
  /// Throws [FormatException] if the API returns an error status.
  sendReceipt(File image) async {
    // Combine base URL with endpoint to get full URL
    final Uri url = Uri.parse('$_baseURL$_receiptEndpoint');

    // Read the image file as bytes
    final bytes = await File(image.path).readAsBytes();
    // Convert the image bytes to base64 string
    final base64Image = base64Encode(bytes);
    // Send HTTP POST request with base64 image
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Token $_apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"document": base64Image}),
    );

    log('Status: ${response.statusCode}');
    log('Body: ${response.body}');
    // Check for successful response (status code 2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      log('Parsed Data: $data');
      // Parse and return ReceiptApiModel from response data
      final model = ReceiptApiModel(
        date:
            data['document']['inference']['prediction']['date']?['value'] ??
            'unknown'.tr(),
        time:
            data['document']['inference']['prediction']['time']?['value'] ??
            'unknown'.tr(),
        receiptNumber:
            data['document']['inference']['prediction']['receipt_number']?['value'] ??
            'unknown'.tr(),
        totalAmount:
            double.tryParse(
              data['document']['inference']['prediction']['total_amount']?['value']
                      ?.toString() ??
                  'unknown'.tr(),
            ) ??
            0.0,

        currency:
            data['document']['inference']['prediction']['locale']?['currency'] ??
            'unknown'.tr(),

        supplier:
            data['document']['inference']['prediction']['supplier_name']?['value'] ??
            'unknown'.tr(),
      );
      log('Model: $model');
      return model;
    } else {
      throw FormatException(
        'Error: ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
}
