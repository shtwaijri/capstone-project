import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/prime/prime_service.dart';

part 'payment_event.dart';
part 'payment_state.dart';

/// PaymentBloc is responsible for handling Prime subscription logic:
/// - Activating the Prime subscription
/// - Checking the remaining subscription days
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  /// Number of days left in the Prime subscription
  late int remainingDay = 0;
  PaymentBloc() : super(PaymentInitial()) {
    /// Handles the activation of Prime subscription
    on<ActivatePrimeEvent>((event, emit) async {
      try {
        await PrimeService.activatePrimeStatus();
        emit(SuccessState());
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });

    /// Checks how many days remain in the Prime subscription
    on<RemainingPrimeDays>((event, emit) async {
      try {
        final result = await PrimeService.getRemainingPrimeDays();
        if (result != null && result > 0) {
          remainingDay = result;
          emit(SubscribedState());
        } else {
          emit(NotSubscribedState());
        }
      } catch (e) {
        emit(ErrorState(e.toString()));
      }
    });
  }
}
