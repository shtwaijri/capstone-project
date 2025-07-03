import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  late int num = 2000;

  PaymentBloc() : super(PaymentInitial()) {
    on<AmountEvent>((event, emit) {
      try {
        num = num * 100;
        print('NUM IS: $num');
        emit(SuccessState());
      } catch (e) {
        emit(ErrorState('Invalid amount format'));
      }
    });
  }
}
