import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/features/members/invite_model/invite_model.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'invite_event.dart';
part 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  InviteBloc() : super(InviteInitial()) {
    on<FetchInvitedListsEvent>(_onFetchInvitedLists);
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<AcceptInviteEvent>(_onAcceptInvite);
  }

  // Fetch Invited Lists (بما أنه لديك ميثود جاهز)
  Future<void> _onFetchInvitedLists(
    FetchInvitedListsEvent event,
    Emitter<InviteState> emit,
  ) async {
    emit(InviteLoadingState());
    try {
      final user = await fetchUserById();
      final response = await supabaseClient
          .from('invite')
          .select(
            'list_id, invite_status, app_user_id, sender_email, invite_id',
          );

      if (response != null) {
        throw Exception('Error fetching invited lists: ${response}');
      }

      final invites = List<Map<String, dynamic>>.from(response);
      emit(InviteLoadedState(invites.cast<InviteModel>()));
    } catch (e) {
      emit(InviteErrorState(e.toString()));
    }
  }

  // Fetch Notifications (بما أن لديك ميثود جاهز)
  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<InviteState> emit,
  ) async {
    emit(InviteLoadingState());
    try {
      final user = await fetchUserById();
      final response = await supabaseClient
          .from('invite')
          .select()
          .eq('app_user_id', user!.userId)
          .order('created_at', ascending: false);

      final invites = List<Map<String, dynamic>>.from(response);
      emit(InviteLoadedState(invites.cast<InviteModel>()));
    } catch (e) {
      emit(InviteErrorState(e.toString()));
    }
  }

  // Accept Invite
  Future<void> _onAcceptInvite(
    AcceptInviteEvent event,
    Emitter<InviteState> emit,
  ) async {
    try {
      final response = await supabaseClient
          .from('invite')
          .update({'invite_status': 'accepted'})
          .eq('invite_id', event.inviteId);
      if (response.error != null) {
        throw Exception('Error accepting invite: ${response.error!.message}');
      }

      final user = await fetchUserById();
      final roleResponse = await supabaseClient
          .from('invite')
          .select('role_id')
          .eq('app_user_id', user!.userId)
          .order('created_at', ascending: false)
          .single();

      final roleId = roleResponse['role_id'];

      await supabaseClient.from('list_user_role').insert({
        'app_user_id': user!.userId,
        'list_id': event.inviteId,
        'role_id': roleId,
      });

      emit(InviteLoadedState([])); // Refresh invites after accepting
    } catch (e) {
      emit(InviteErrorState(e.toString()));
    }
  }
}
