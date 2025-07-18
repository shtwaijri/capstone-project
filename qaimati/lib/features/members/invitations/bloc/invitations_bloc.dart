// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/members/invitations/model/invite_model.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'invitations_event.dart';
part 'invaitations_state.dart';

class InvitationsBloc extends Bloc<InvitationsEvent, InvitationsState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  InvitationsBloc() : super(InviteInitialState()) {
    on<FetchInvitedListsEvent>(_onFetchInvitations);
    on<AcceptInviteEvent>(_onAcceptInvitation);
    on<RejectInviteEvent>(_onRejectInvitation);
  }

  FutureOr<void> _onAcceptInvitation(
    AcceptInviteEvent event,
    Emitter<InvitationsState> emit,
  ) async {
    try {
      final updatedInvite = await _supabaseClient
          .from('invite')
          .update({'invite_status': 'accepted'})
          .eq('invite_id', event.inviteId)
          .select()
          .single();

      AppUserModel? user = await fetchUserById();
      final roleId = await SupabaseConnect.getRoleIdByName("member");

      await _supabaseClient.from('list_user_role').insert({
        'app_user_id': user!.userId,
        'list_id': updatedInvite['list_id'],
        'role_id': roleId,
      });

      add(FetchInvitedListsEvent());
    } catch (e) {
      emit(InviteErrorState('Error accepting invitation'));
    }
  }

  FutureOr<void> _onRejectInvitation(
    RejectInviteEvent event,
    Emitter<InvitationsState> emit,
  ) async {
    try {
      await _supabaseClient
          .from('invite')
          .update({'invite_status': 'rejected'})
          .eq('invite_id', event.inviteId);

      add(FetchInvitedListsEvent());
    } catch (e) {
      emit(InviteErrorState('Error rejecting invitation'));
    }
  }

  FutureOr<void> _onFetchInvitations(
    FetchInvitedListsEvent event,
    Emitter<InvitationsState> emit,
  ) async {
    emit(InviteLoadingState());
    try {
      AppUserModel? user = await fetchUserById();
      final response = await _supabaseClient
          .from('invite')
          .select(
            'list_id, invite_status, app_user_id, sender_email, invite_id, list(name)',
          )
          .eq('receiver_email', user!.email)
          .order('created_at', ascending: false);

      final pendingInvites = response.where((invite) {
        return invite['invite_status'] == null ||
            invite['invite_status'] == 'pending';
      }).toList();

      final updatedInvites = pendingInvites.map((invite) {
        final listInfo = invite['list'] as Map<String, dynamic>?;
        invite['list_name'] = listInfo?['name'] ?? 'Unknown List';
        return invite;
      }).toList();

      emit(InviteLoadedState(invitedLists: updatedInvites, notifications: []));
    } catch (e) {
      emit(InviteErrorState('Failed to load invitations'));
    }
  }
}
