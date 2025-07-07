import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/members/add_members/add_member_service.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  String email = '';
  AddMemberBloc() : super(AddMemberInitial()) {
    on<onAddEmailEvent>(_onAddEmail);

    on<SendInviteEvent>(_onSendInvite);
  }

  FutureOr<void> _onAddEmail(
    onAddEmailEvent event,
    Emitter<AddMemberState> emit,
  ) {
    email = event.email;
  }

  FutureOr<void> _onSendInvite(
    SendInviteEvent event,
    Emitter<AddMemberState> emit,
  ) async {
    if (email.trim().isEmpty) {
      emit(AddMemberFailure("Email can not be empty"));
      return;
    }
    emit(AddMemberLoading());

    try {
      //call send invite method
      await sendInvite(event.email, event.listId);
      emit(AddMemberSuccess());
    } catch (e) {
      emit(AddMemberFailure(e.toString()));
    }
  }
}
