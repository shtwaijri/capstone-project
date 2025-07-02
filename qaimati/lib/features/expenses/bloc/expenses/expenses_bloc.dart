import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc() : super(ExpensesInitial()) {
    on<ExpensesEvent>((event, emit) {});
  }
}
