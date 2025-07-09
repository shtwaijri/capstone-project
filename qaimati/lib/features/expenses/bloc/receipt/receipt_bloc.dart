import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/models/receipt/receipt_api_model.dart';
import 'package:qaimati/models/receipt/receipt_model.dart';
import 'package:qaimati/repository/receipt_repository/receipt_api.dart';
import 'package:qaimati/repository/receipt_repository/receipt_supabeas.dart';
import 'package:qaimati/utilities/helper/image_picker_helper.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

/// BLoC responsible for handling receipt image upload, data extraction, and saving to Supabase.
///
/// Emits:
/// - [LoadingState] when image is being picked and processed.
/// - [SuccessState] when receipt data is successfully extracted.
/// - [ReceiptInitial] when no image is selected or reset is triggered.
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  /// Controller for store name input field.
  final TextEditingController storController = TextEditingController();

  /// Controller for total amount input field.
  final TextEditingController totalController = TextEditingController();
  late String supplier;
  late String receiptFileUrl;
  late String date;
  late String time;
  late String receiptNumber;
  late double totalAmount;
  late String currency;
  // String? receiptFileUrl;

  ReceiptBloc() : super(ReceiptInitial()) {
    on<ReceiptEvent>((event, emit) {});
    on<UplaodReceiptEvent>(uplaodReceiptMethod); // When uploading image
    on<SaveReceiptEvent>(saveMethod); // When saving receipt
  }

  /// Picks an image from the user's gallery or camera, sends it to the OCR API,
  /// then updates UI state with the extracted data.
  FutureOr<void> uplaodReceiptMethod(
    UplaodReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(LoadingState());
    try {
      final image = await ImagePickerHelper().pickImage();
      if (image != null) {
        final data = await ReceiptApi().sendReceipt(image);
        receiptFileUrl = await ReceiptSupabase().uploadReceiptToStorage(
          receiptData: image.readAsBytesSync(),
        );
        storController.text = data.supplier;
        totalController.text = data.totalAmount.toString();
        date = data.date;
        time = data.time;
        receiptNumber = data.receiptNumber;
        currency = data.currency;

        emit(SuccessState(image, data));
      } else {
        log('No image selected.');
        emit(ReceiptInitial());
      }
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  /// Saves the receipt data into Supabase storage.
  ///
  /// Uses the previously uploaded receiptFileUrl and extracted/entered data.
  FutureOr<void> saveMethod(
    SaveReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    try {
      double total = double.tryParse(totalController.text) ?? 0.0;
      await ReceiptSupabase().addNewReceipt(
        receipt: ReceiptModel(
          receiptFileUrl: receiptFileUrl,
          supplier: storController.text,
          receiptNumber: receiptNumber,
          totalAmount: convertToSAR(total, currency),
          currency: currency,
          createdAt: DateTime.now(),
        ),
      );
      storController.clear();
      totalController.clear();
      emit(ReceiptInitial());
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }
}

/// Converts a given amount from a specific currency to Saudi Riyal (SAR).
///
/// Uses fixed exchange rates defined in [exchangeRates] map.
///
/// Parameters:
/// - [amount]: The amount to convert.
/// - [fromCurrency]: The original currency code (e.g. 'USD', 'AED').
///
/// Returns:
/// - Amount converted to SAR as `double`.
double convertToSAR(double amount, String fromCurrency) {
  const exchangeRates = {
    // Gulf and Arab currencies
    'SAR': 1.00, // Saudi Riyal
    'AED': 1.02, // UAE Dirham
    'KWD': 12.30, // Kuwaiti Dinar
    'OMR': 9.75, // Omani Rial
    'QAR': 1.03, // Qatari Riyal
    'BHD': 9.95, // Bahraini Dinar
    'EGP': 0.23, // Egyptian Pound
    'LYD': 0.78, // Libyan Dinar
    'DZD': 0.028, // Algerian Dinar
    'TND': 1.22, // Tunisian Dinar
    'MAD': 0.37, // Moroccan Dirham
    'SDG': 0.006, // Sudanese Pound
    'YER': 0.015, // Yemeni Rial
    'SYP': 0.0004, // Syrian Pound
    'IQD': 0.0029, // Iraqi Dinar
    'JOD': 5.29, // Jordanian Dinar
    'LBP': 0.00025, // Lebanese Pound
    // Major global currencies
    'USD': 3.75, // US Dollar
    'EUR': 4.10, // Euro
    'GBP': 4.75, // British Pound
    'CAD': 2.80, // Canadian Dollar
    'AUD': 2.50, // Australian Dollar
    'NZD': 2.30, // New Zealand Dollar
    'CHF': 4.15, // Swiss Franc
    'SEK': 0.36, // Swedish Krona
    'NOK': 0.35, // Norwegian Krone
    'DKK': 0.55, // Danish Krone
    'RUB': 0.042, // Russian Ruble
    'CZK': 0.16, // Czech Koruna
    'PLN': 0.95, // Polish Zloty
    'HUF': 0.011, // Hungarian Forint
    // Asian currencies
    'INR': 0.045, // Indian Rupee
    'PKR': 0.013, // Pakistani Rupee
    'BDT': 0.034, // Bangladeshi Taka
    'LKR': 0.042, // Sri Lankan Rupee
    'NPR': 0.028, // Nepalese Rupee
    'CNY': 0.52, // Chinese Yuan
    'JPY': 0.026, // Japanese Yen
    'KRW': 0.0027, // South Korean Won
    'IDR': 0.00024, // Indonesian Rupiah
    'MYR': 0.80, // Malaysian Ringgit
    'THB': 0.10, // Thai Baht
    'VND': 0.00016, // Vietnamese Dong
    'SGD': 2.80, // Singapore Dollar
    'HKD': 0.48, // Hong Kong Dollar
    'TWD': 0.12, // Taiwan Dollar
    'PHP': 0.066, // Philippine Peso
    // 🌍 African currencies
    'ZAR': 0.20, // South African Rand
    'NGN': 0.0024, // Nigerian Naira
    'KES': 0.026, // Kenyan Shilling
    'GHS': 0.32, // Ghanaian Cedi
    'ETB': 0.067, // Ethiopian Birr
    // 🌎 Latin American & North American currencies
    'MXN': 0.22, // Mexican Peso
    'BRL': 0.72, // Brazilian Real
    'ARS': 0.004, // Argentine Peso
    'CLP': 0.0042, // Chilean Peso
    'PEN': 1.02, // Peruvian Sol
    'COP': 0.001, // Colombian Peso
    // Fallback for unknown currencies
    'UNKNOWN': 1.0,
  };

  // Use exchange rate if available, otherwise fallback to 1.0
  final rate = exchangeRates[fromCurrency.toUpperCase()] ?? 1.0;

  // Return the converted amount in SAR
  return amount * rate;
}
