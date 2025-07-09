import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/models/receipt/receipt_model.dart';
import 'package:qaimati/layer_data/receipt_data.dart';
import 'package:qaimati/repository/receipt_repository/receipt_supabeas.dart';
part 'expenses_event.dart';
part 'expenses_state.dart';

/// BLoC for managing monthly expenses logic:
/// - Load receipts by month
/// - Delete receipt
/// - Update receipt
///
/// Emits:
/// - [LoadingState] while waiting for operations.
/// - [SuccessState] when data is successfully loaded or updated.
/// - [ErrorState] if an error occurs during any operation.
class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  /// Currently displayed month
  DateTime displayedDate = DateTime.now();

  /// Total amount for the displayed month
  double total = 0.0;

  /// Controllers for form fields
  final TextEditingController totalController = TextEditingController();
  final TextEditingController storeController = TextEditingController();

  late DateTime newDate;

  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesEvent>((event, emit) {});

    on<MonthChangedEvent>(monthChangedMethod);
    on<DeleteReceiptEvent>(deleteReceiptMethod);
    on<UpdateReceiptEvent>(updateReceiptMethod);
    on<CheckPirEvent>(testCheckMethod);
    on<SetDateEvent>((event, emit) {
      displayedDate = event.newDate;
    });
  }

  /// Reloads all receipt data and total amount for the currently displayed month,
  /// then emits a [SuccessState] with the updated information.
  Future<void> _reloadCurrentMonthData(Emitter<ExpensesState> emit) async {
    final year = displayedDate.year;
    final month = displayedDate.month;

    final data = await GetIt.I.get<ReceiptData>().loadMonthlyDataFromSupabase(
      year: year,
      month: month,
    );
    total = await ReceiptSupabase().getMonthlyTotalAmount(
      year: year,
      month: month,
    );

    emit(SuccessState(data, displayedDate));
    storeController.clear();
    totalController.clear();
  }

  /// Called when the user switches to a different month in the UI.
  ///
  /// Fetches receipts and total for that month from Supabase.
  FutureOr<void> monthChangedMethod(
    MonthChangedEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      final newDate = DateTime(event.year, event.month);
      displayedDate = newDate;
      await _reloadCurrentMonthData(emit);
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  /// Called when the user deletes a specific receipt.
  ///
  /// Deletes from Supabase, reloads data for current displayed month.
  FutureOr<void> deleteReceiptMethod(
    DeleteReceiptEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      // Delete receipt from Supabase
      await ReceiptSupabase().deleteReceipt(event.receiptId);
      await _reloadCurrentMonthData(emit);
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  /// Called when the user updates a receipt's data.
  ///
  /// Updates the receipt in Supabase, then reloads the data for current month.
  FutureOr<void> updateReceiptMethod(
    UpdateReceiptEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      // Update receipt in Supabase
      await ReceiptSupabase().updateReceipt(event.updatedData, event.receiptId);
      await _reloadCurrentMonthData(emit);
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  FutureOr<void> testCheckMethod(
    CheckPirEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      await ReceiptSupabase().checkAddReceiptEligibility();
      emit(IsPremiumiState());
    } catch (_) {
      emit(IsNotPremiumiState("receiptLimitReached"));
    }
  }
}
