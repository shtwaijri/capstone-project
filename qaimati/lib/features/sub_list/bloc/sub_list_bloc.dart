import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'sub_list_event.dart';
part 'sub_list_state.dart';

class SubListBloc extends Bloc<SubListEvent, SubListState> {
  int number = 0;
  bool isItemImportant = false; // Add a state variable for importance
  String? currentExternalId;

  TextEditingController itemController = TextEditingController();
  SubListBloc() : super(SubListInitial()) {
    on<SubListEvent>((event, emit) async {
         

    });
    add(SubListEvent());
    on<IncrementNumberEvent>(incrementNumberMethod);
    on<DecrementNumberEvent>(decrementNumberMethod);
    on<ChooseImportanceEvent>(chooseImportanceMethod);
  }

  FutureOr<void> incrementNumberMethod(
    IncrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    number++;
    emit(ChangeNumberState(number: (number)));
  }

  FutureOr<void> decrementNumberMethod(
    DecrementNumberEvent event,
    Emitter<SubListState> emit,
  ) {
    if (number > 0) {
      number--;
    }

    emit(ChangeNumberState(number: (number)));
  }

  FutureOr<void> chooseImportanceMethod(
    ChooseImportanceEvent event,
    Emitter<SubListState> emit,
  ) {
    isItemImportant = event.isImportant; // Update the bloc's internal state
    emit(ChooseImportanceState(isImportant: isItemImportant));
  }
    Future<void> initializeOneSignalAndRequestPermissions() async {
    
    // قم بتسجيل الدخول بالمعرف الخارجي فقط بعد التأكد من الاشتراك
    if (currentExternalId == null) {
      final newExternalId = 'user_${math.Random().nextInt(1000000)}';
      await OneSignal.login(newExternalId);
        await OneSignal.login(newExternalId);
      currentExternalId = newExternalId;
      log("Logged in with External ID: $currentExternalId");
    }

    
  }
}
