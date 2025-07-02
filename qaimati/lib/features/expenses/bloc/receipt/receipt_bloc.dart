import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/expenses/model/receipt_api_model.dart';
import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/features/expenses/repository/receipt_api.dart';
import 'package:qaimati/features/expenses/repository/receipt_supabeas.dart';
import 'package:qaimati/utilities/helper/image_picker_helper.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

/// BLoC responsible for handling receipt image upload and extraction of receipt data.
///
/// Methods:
/// - [uplaodReceiptMethod] triggers image picking, sends the image to the receipt API,
///   and updates the text controllers with extracted supplier and total amount.
///
/// Emits:
/// - [LoadingState] while waiting for image picking and API response.
/// - [SuccessState] when image is successfully processed and data is extracted.
/// - [ReceiptInitial] when no image is selected or after reset.
class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  /// Controller for store name input field.
  final TextEditingController storController = TextEditingController();

  /// Controller for total amount input field.
  final TextEditingController totalController = TextEditingController();

  late String supplier;
  late String date;
  late String time;
  late String receiptNumber;
  late double totalAmount;
  late String currency;
  // String? receiptFileUrl;

  ReceiptBloc() : super(ReceiptInitial()) {
    on<ReceiptEvent>((event, emit) {});
    on<UplaodReceiptEvent>(uplaodReceiptMethod);
    on<SaveReceiptEvent>(saveMethod);
  }

  /// Method to handle uploading a receipt image.
  FutureOr<void> uplaodReceiptMethod(
    UplaodReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(LoadingState());
    final image = await ImagePickerHelper().pickImage();
    if (image != null) {
      final data = await ReceiptApi().sendReceipt(image);

      storController.text = data.supplier;
      totalController.text = data.totalAmount.toString();

      supplier = data.supplier;
      date = data.date;
      time = data.time;
      receiptNumber = data.receiptNumber;
      totalAmount = data.totalAmount;
      currency = data.currency;

      emit(SuccessState(image, data));
    } else {
      log('No image selected.');
      emit(ReceiptInitial());
    }
  }

  FutureOr<void> saveMethod(
    SaveReceiptEvent event,
    Emitter<ReceiptState> emit,
  ) async {
    await ReceiptSupabeas(
      userId: '264db79b-d37b-4635-899c-35b582db9102',
    ).addNewReceipt(
      receipt: ReceiptModel(
        supplier: supplier,
        receiptNumber: receiptNumber,
        totalAmount: totalAmount,
        currency: currency,
        createdAt: DateTime.now(),
      ),
    );
  }
}
