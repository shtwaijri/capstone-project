import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<LoadProfileEvent>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      emit(
        ProfileLoaded(
          name: user.userMetadata?['name'] ?? '',
          email: user.email ?? '',
        ),
      );
    }
  }

  Future<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        await Supabase.instance.client
            .from('app_user')
            .update({'name': event.newName})
            .eq('auth_user_id', userId);

        emit(ProfileUpdated());
      }
    } catch (e) {
      emit(ProfileError('Failed to update name'));
    }
  }

  Future<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: event.newEmail),
      );
      emit(ProfileUpdated());
    } catch (e) {
      emit(ProfileError('Failed to update email'));
    }
  }
}
