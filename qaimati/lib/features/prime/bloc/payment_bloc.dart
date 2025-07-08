import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/prime/prime_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late int num = 10;
  late int remainingDay = 0;
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
    on<ActivatePrimeEvent>((event, emit) async {
      try {
        await PrimeService.activatePrimeStatus();
        emit(SuccessState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
    on<RemainingPrimeDays>((event, emit) async {
      try {
        remainingDay = (await PrimeService.getRemainingPrimeDays())!;
        emit(SuccessState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
