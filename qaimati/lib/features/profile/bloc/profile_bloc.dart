// ignore_for_file: depend_on_referenced_packages

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

  //method for updating the name
  FutureOr<void> _onUpdateName(
    UpdateNameEvent event,
    Emitter<ProfileState> emit,
  ) async {
    //get the user id from authlayer
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

    //check if the user logged in
    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    //update the name in app user table
    await Supabase.instance.client
        .from("app_user")
        .update({'name': event.newName})
        .eq("auth_user_id", userId);

    //emit a new state after updating the name
    final currState = state;
    if (currState is ProfileLoadedState) {
      emit(
        ProfileLoadedState(
          name: event.newName, //new name
          email: currState.email, //retain the old email
          isArabicState: currState.isArabicState, //retain the old lang
          isDarkModeState: currState.isDarkModeState, //retain the old theme
        ),
      );
    }
  }

  FutureOr<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    //get the userId from authlayer
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    try {
      //update the email using supabase auth service
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(email: event.newEmail),
      );

      await Supabase.instance.client
          .from("app_user")
          .update({'email': event.newEmail})
          .eq("auth_user_id", userId);

      //emit a new state after updating the email
      final currentState = state;
      if (currentState is ProfileLoadedState) {
        emit(
          ProfileLoadedState(
            name: currentState.name, //retain the name
            email: event.newEmail, //new email
            isArabicState: currentState.isArabicState, //retain old lang
            isDarkModeState: currentState.isDarkModeState, //retain old theme
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
      final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();

      if (userId == null) {
        emit(ProfileError("User not logged in"));
        return;
      }

      //fetch the user's profile setting from app user table
      final response = await Supabase.instance.client
          .from("app_user")
          .select('language_code, theme_mode, name, email')
          .eq("auth_user_id", userId)
          .maybeSingle();

      if (response == null) {
        emit(ProfileError("There is no data for this user"));
        return;
      }

      //extract the data from the response
      final name = response['name'] ?? 'Guest'; //default guest if null
      final email = response['email'] ?? 'unknown@email.com';
      final isArabic = response['language_code'] == 'ar';
      final isDarkMode = response['theme_mode'] == 'dark';

      ThemeController.toggleTheme(isDarkMode);

      emit(
        ProfileLoadedState(
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
    final newLangCode = event.isArabic ? 'ar' : 'en'; //determine the new lang

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    //update the lang in app user table
    final result = await Supabase.instance.client
        .from("app_user")
        .update({'language_code': newLangCode})
        .eq("auth_user_id", userId);

    if (result == null) {
      emit(ProfileError("Failed to update language"));
      return;
    }

    //emit the updated profile with the new lang
    final currentState = state;
    if (currentState is ProfileLoadedState) {
      emit(
        ProfileLoadedState(
          isArabicState: event.isArabic, //update the lang
          isDarkModeState: currentState.isDarkModeState, //retain theme
          name: currentState.name, //retain the name
          email: currentState.email, //retain the email
        ),
      );
    }
  }

  FutureOr<void> _onClickColor(
    ClickChangeColorEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();
    final newThemeMode = event.isDarkMode
        ? 'dark'
        : 'light'; //determine the new theme

    if (userId == null) {
      emit(ProfileError("User not logged in"));
      return;
    }

    //update app user table with the new theme
    await Supabase.instance.client
        .from("app_user")
        .update({'theme_mode': newThemeMode})
        .eq("auth_user_id", userId);

    //emit the updated profile with the new theme

    final currenrState = state;
    if (currenrState is ProfileLoadedState) {
      emit(
        ProfileLoadedState(
          isArabicState: currenrState.isArabicState,
          isDarkModeState: event.isDarkMode,
          name: currenrState.name,
          email: currenrState.email,
        ),
      );
    }
  }
}
