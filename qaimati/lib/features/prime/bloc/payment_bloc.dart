import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:moyasar/moyasar.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late int num = 10;

  PaymentBloc() : super(PaymentInitial()) {
    on<AmountEvent>((event, emit) {
      try {
        num = num * 100;
        log('NUM IS: $num');
        emit(SuccessState());
      } catch (e) {
        emit(ErrorState('Invalid amount format'));
      }
    });
  }
}
