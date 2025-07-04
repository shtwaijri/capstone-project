import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_list_event.dart';
part 'add_list_state.dart';

class AddListBloc extends Bloc<AddListEvent, AddListState> {
  int selectColor = 1;
  changeColor(int index) { // this function to change color when user click on any color, i will use the select color to store it in datebase
    selectColor = index;
    // ignore: invalid_use_of_visible_for_testing_member
    emit(UpdateState());
  }

  AddListBloc() : super(AddListInitial()) {
    on<AddListEvent>((event, emit) {});
  }
}
