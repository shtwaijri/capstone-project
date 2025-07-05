import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/style/theme/theme_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<UpdateNameEvent>(_onUpdateName);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<LoadProfileSettingEvent>(_onLoadProfile);
    on<ClickChangeLangEvent>(_onClickLang);
    on<ClickChangeColorEvent>(_onClickColor);
  }

  FutureOr<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    await Supabase.instance.client
        .from("app_user")
        .update({'name': event.newName})
        .eq("auth_user_id", userId);

    final currState = state;
    if (currState is ProfileLoaded) {
      emit(
        ProfileLoaded(
          name: event.newName,
          email: currState.email,
          isArabicState: currState.isArabicState,
          isDarkModeState: currState.isDarkModeState,
        ),
      );
    }
  }

  FutureOr<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: event.newEmail),
      );

      await Supabase.instance.client
          .from("app_user")
          .update({'email': event.newEmail})
          .eq("auth_user_id", userId);

      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(
          ProfileLoaded(
            name: currentState.name,
            email: event.newEmail,
            isArabicState: currentState.isArabicState,
            isDarkModeState: currentState.isDarkModeState,
          ),
        );
      }
    } catch (e) {
      emit(ProfileError("Failed to update email: $e"));
    }
  }

  FutureOr<void> _onLoadProfile(
    LoadProfileSettingEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        emit(ProfileError("User not logged in"));
        return;
      }

      final response = await Supabase.instance.client
          .from("app_user")
          .select('language_code, theme_mode, name, email')
          .eq("auth_user_id", userId)
          .maybeSingle();

      if (response == null) {
        emit(ProfileError("There is no data for this user"));
        return;
      }

      final name = response['name'] ?? 'Guest';
      final email = response['email'] ?? 'unknown@email.com';
      final isArabic = response['language_code'] == 'ar';
      final isDarkMode = response['theme_mode'] == 'dark';

      ThemeController.toggleTheme(isDarkMode);

      emit(
        ProfileLoaded(
          name: name,
          email: email,
          isArabicState: isArabic,
          isDarkModeState: isDarkMode,
        ),
      );
    } catch (e) {
      emit(ProfileError("loading Failed: $e"));
    }
  }

  FutureOr<void> _onClickLang(
    ClickChangeLangEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();
    final newLangCode = event.isArabic ? 'ar' : 'en';

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    final result = await Supabase.instance.client
        .from("app_user")
        .update({'language_code': newLangCode})
        .eq("auth_user_id", userId);

    if (result == null) {
      emit(ProfileError("Failed to update language"));
      return;
    }

    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(
        ProfileLoaded(
          isArabicState: event.isArabic,
          isDarkModeState: currentState.isDarkModeState,
          name: currentState.name,
          email: currentState.email,
        ),
      );
    }
  }

  FutureOr<void> _onClickColor(
    ClickChangeColorEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = await GetIt.I.get<AuthLayer>().getCurrentSessionId();
    final newThemeMode = event.isDarkMode ? 'dark' : 'light';

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    await Supabase.instance.client
        .from("app_user")
        .update({'theme_mode': newThemeMode})
        .eq("auth_user_id", userId);

    final currenrState = state;
    if (currenrState is ProfileLoaded) {
      emit(
        ProfileLoaded(
          isArabicState: currenrState.isArabicState,
          isDarkModeState: event.isDarkMode,
          name: currenrState.name,
          email: currenrState.email,
        ),
      );
    }
  }
}
