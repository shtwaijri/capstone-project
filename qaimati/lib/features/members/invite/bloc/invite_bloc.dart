import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/members/invite/model/invite_model.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  InviteBloc() : super(InviteInitialState()) {
    on<FetchInvitedListsEvent>(_onFetchInvitations);
    on<AcceptInviteEvent>(_onAcceptInvitation);
  }

  FutureOr<void> _onAcceptInvitation(
    AcceptInviteEvent event,
    Emitter<InviteState> emit,
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
      log('error accepting invite: $e');
      emit(InviteErrorState('Error accepting invitation'));
    }
  }

  FutureOr<void> _onFetchInvitations(
    FetchInvitedListsEvent event,
    Emitter<InviteState> emit,
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

      final invited = List<Map<String, dynamic>>.from(response);

      final notiResponse = await _supabaseClient
          .from('invite')
          .select()
          .eq('app_user_id', user.userId)
          .order('created_at', ascending: false);

      final notifications = <InviteModel>[];
      for (var item in notiResponse) {
        notifications.add(InviteModelMapper.fromMap(item));
      }

      final updatedInvites = invited.map((invite) {
        final listInfo = invite['list'] as Map<String, dynamic>;
        invite['list_name'] = listInfo['name'] ?? 'Unknown List';
        return invite;
      }).toList();

      emit(
        InviteLoadedState(
          invitedLists: updatedInvites,
          notifications: notifications,
        ),
      );
    } catch (e) {
      log('Error fetching invited lists: $e');
      emit(InviteErrorState('Failed to load data'));
    }
  }
}
