import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'check_box_event.dart';
part 'check_box_state.dart';

class CheckBoxBloc extends Bloc<CheckBoxEvent, CheckBoxState> {
  CheckBoxBloc() : super(CheckboxValueState(false)) {
    on<PressCheckBoxEvent>((event, emit) {
      emit(CheckboxValueState(event.isChecked));
    });
  }
}
