import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'sub_list_event.dart';
part 'sub_list_state.dart';

class SubListBloc extends Bloc<SubListEvent, SubListState> {
 int number=0;
   bool isItemImportant = false; // Add a state variable for importance

 TextEditingController itemController=TextEditingController();
  SubListBloc() : super(SubListInitial()) {
    on<SubListEvent>((event, emit) {
    
    });
    on<IncrementNumberEvent>(incrementNumberMethod);
    on<DecrementNumberEvent>(decrementNumberMethod);
    on<ChooseImportanceEvent>(chooseImportanceMethod);
  }

  FutureOr<void> incrementNumberMethod(IncrementNumberEvent event, Emitter<SubListState> emit) {
    number++;
    emit(ChangeNumberState(number: (number)));
  }

  FutureOr<void> decrementNumberMethod(DecrementNumberEvent event, Emitter<SubListState> emit) {
    number--;
     emit(ChangeNumberState(number: (number)));
  }


  FutureOr<void> chooseImportanceMethod(ChooseImportanceEvent event, Emitter<SubListState> emit) {
     isItemImportant = event.isImportant; // Update the bloc's internal state
    emit(ChooseImportanceState(isImportant: isItemImportant));
  }
}
