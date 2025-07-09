// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

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
    on<DeleteMemberEvent>(_onDeleteMember);
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

  Future<void> _onDeleteMember(
    DeleteMemberEvent event,
    Emitter<AddMemberState> emit,
  ) async {
    emit(AddMemberLoading());

    final currentUserId = await GetIt.I.get<AuthLayer>().getCurrentSessionId();

    if (currentUserId == null) {
      emit(AddMemberErrorState("User not logged in"));
      return;
    }

    final isAdmin = await _checkIfAdmin(event.listId, currentUserId);

    if (!isAdmin) {
      emit(AddMemberErrorState("Only admin can delete members"));
      return;
    }

    try {
      final response = await _supabaseClient
          .from('list_user_role')
          .delete()
          .eq('app_user_id', event.userId)
          .eq('list_id', event.listId);
      if (response.error != null) {
        emit(
          AddMemberFailure(
            "Error while deleting member: ${response.error!.message}",
          ),
        );
        return;
      }

      // Emit success state after deletion
      emit(AddMemberSuccess());

      // Trigger a fetch of updated member list
      add(FetchMembersEvent(listId: event.listId));
    } catch (e) {
      emit(AddMemberFailure('Failed to delete member: $e'));
    }
  }

  // Updated checkIfAdmin with null checks
  Future<bool> _checkIfAdmin(String listId, String userId) async {
    try {
      final response = await _supabaseClient
          .from('list_user_role')
          .select('role_id')
          .eq('list_id', listId)
          .eq('app_user_id', userId)
          .single();

      if (response == null) {
        return false;
      }

      return response['role_id'] ==
          'admin'; // Ensure 'admin' is the correct value
    } catch (e) {
      return false; // Return false in case of any error
    }
  }

  //method to check if the user is the admin
  //to use it in delete members
  //only admin can delete a member
  // Future<bool> _checkIfAdmin(String listId, String userId) async {
  //   final response = await _supabaseClient
  //       .from('list_user_role')
  //       .select('role_id')
  //       .eq('list_id', listId)
  //       .eq('app_user_id', userId)
  //       .single();

  //   if (response != null && response['role_id'] == 'admin') {
  //     return true;
  //   }
  //   return false;
  // }
}
