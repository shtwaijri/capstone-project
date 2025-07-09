// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/members/add_member/add_member_service.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'add_member_event.dart';
part 'add_member_state.dart';

class AddMemberBloc extends Bloc<AddMemberEvent, AddMemberState> {
  String email = '';
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  AddMemberBloc() : super(AddMemberInitial()) {
    on<AddEmailEvent>(_onAddEmail);

    on<SendInviteEvent>(_onSendInvite);
    on<FetchMembersEvent>(_onFetchMembers);
  }

  FutureOr<void> _onAddEmail(
    AddEmailEvent event,
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

  Future<void> _onFetchMembers(
    FetchMembersEvent event,
    Emitter<AddMemberState> emit,
  ) async {
    emit(AddMemberInitial());
    try {
      final response = await _supabaseClient
          .from('invite')
          .select('receiver_email')
          .eq('list_id', event.listId)
          .eq('invite_status', 'accepted')
          .order('created_at', ascending: false);

      final members = List<String>.from(
        response.map((e) => e['receiver_email']),
      );

      emit(AddMemberLoadedState(members: members));
    } catch (e) {
      emit(AddMemberErrorState('Failed to load members'));
    }
  }
}
