// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  // final String _name = '';

  CompleteProfileBloc() : super(CompleteProfileInitial()) {
    on<SendNameEvent>((event, emit) async {
      //check if the name is empty
      if (event.name.trim().isEmpty) {
        //emit an error if the name is empty
        emit(
          CompleteProfileInitial(
            name: event.name,
            nameError: tr('nameRequired'),
          ),
        );
        return;
      }
      await _submitProfile(event, emit);
    });
  }
  //method to handle the process of the submitting profile
  Future<void> _submitProfile(
    SendNameEvent event,
    Emitter<CompleteProfileState> emit,
  ) async {
    emit(CompleteProfileLoading());

    try {
      //get the userID
      final userId = GetIt.I.get<AuthLayer>().getCurrentSessionId();
      if (userId == null) {
        throw Exception(tr('notLoggedIn'));
      }
      //check if the user already have a profile in supabase
      final existingUser = await Supabase.instance.client
          .from('app_user')
          .select('name')
          .eq('auth_user_id', userId)
          .maybeSingle();
      //return an error if the user have a profile
      if (existingUser != null &&
          existingUser['name'] != null &&
          existingUser['name'].toString().isNotEmpty) {
        emit(CompleteProfileFailure(tr('haveProfile'), error: ''));
        return;
      }

      await AuthLayer.completeUserProfile(
        userId: userId,
        name: event.name.trim(),
        email: Supabase.instance.client.auth.currentSession?.user.email,
      );

      emit(CompleteProfileSuccess());
    } catch (e) {
      emit(CompleteProfileFailure(e.toString(), error: e.toString()));
    }
  }
}
