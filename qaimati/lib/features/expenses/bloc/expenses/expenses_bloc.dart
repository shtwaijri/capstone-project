import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/features/expenses/receipt_data.dart';
import 'package:qaimati/features/expenses/repository/receipt_supabeas.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  DateTime displayedDate = DateTime.now();
  double total = 0.0;
  final TextEditingController totalController = TextEditingController();
  final TextEditingController storeController = TextEditingController();
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesEvent>((event, emit) {});

    on<MonthChangedEvent>(monthChangedMethod);
    on<DeleteReceiptEvent>(deleteReceiptMethod);
    on<UpdateReceiptEvent>(updateReceiptMethod);
  }

  FutureOr<void> monthChangedMethod(
    MonthChangedEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      final newDate = DateTime(event.year, event.month);
      displayedDate = newDate;
      final data = await GetIt.I.get<ReceiptData>().loadMonthlyDataFromSupabase(
        year: event.year,
        month: event.month,
      );
      total = await ReceiptSupabase().getMonthlyTotalAmount(
        year: event.year,
        month: event.month,
      );
      emit(SuccessState(data, newDate));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  FutureOr<void> deleteReceiptMethod(
    DeleteReceiptEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      await ReceiptSupabase().deleteReceipt(event.receiptId);

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
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }

  FutureOr<void> updateReceiptMethod(
    UpdateReceiptEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      await ReceiptSupabase().updateReceipt(event.updatedData, event.receiptId);

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
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }
}
