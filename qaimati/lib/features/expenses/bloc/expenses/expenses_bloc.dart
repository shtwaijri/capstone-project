import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/expenses/model/receipt_model.dart';
import 'package:qaimati/features/expenses/receipt_data.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesEvent>((event, emit) {});
    on<LoadingReceiptEvent>(loadMethod);
  }

  FutureOr<void> loadMethod(
    LoadingReceiptEvent event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(LoadingState());
    try {
      final data = await GetIt.I.get<ReceiptData>().loadDataFromSupabase();
      emit(SuccessState(data));
    } catch (error) {
      emit(ErrorState(error.toString()));
    }
  }
}
