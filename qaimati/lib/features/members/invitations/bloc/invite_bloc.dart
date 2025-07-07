import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/repository/supabase.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qaimati/models/invite_model/invite_model.dart';
import 'package:qaimati/models/invite_model/invite_model.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  InviteBloc() : super(InviteInitialState()) {
    on<FetchInvitedListsEvent>(_onFetchInvitations);
    on<AcceptInviteEvent>(_onAcceptInvitation);
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
      for (var item in response) {
        notifications.add(InviteModelMapper.fromMap(item) as InviteModel);
      }

      emit(
        InviteLoadedState(invitedLists: invited, notifications: notifications),
      );
    } catch (e) {
      log('Error fetching invited lists: $e');
    }
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

      log("Invite accepted: $updatedInvite");

      AppUserModel? user = await fetchUserById();

      final roleId = await SupabaseConnect.getRoleIdByName("member");

      await _supabaseClient.from('list_user_role').insert({
        'app_user_id': user!.userId,
        'list_id': updatedInvite['list_id'],
        'role_id': roleId,
      });

      log(
        "Role assigned to user ${user.userId} in list ${updatedInvite['list_id']}",
      );
      add(FetchInvitedListsEvent());
    } catch (e) {
      log('error accepting invite: $e');
      emit(
        InviteAcceptErrorState(
          "Something went wrong while accepting the invite.",
        ),
      );
    }
  }
}
