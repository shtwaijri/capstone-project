import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  String _name = '';

  CompleteProfileBloc() : super(CompleteProfileInitial()) {
    on<AddNameEvent>((event, emit) {
      emit(CompleteProfileInitial(name: event.name));
      _name = event.name;
    });

    on<SendNameEvent>((event, emit) async {
      if (_name.trim().isEmpty) {
        emit(
          CompleteProfileInitial(
            name: _name,
            nameError: 'The name is required',
          ),
        );
        return;
      }

      await _submitProfile(event, emit);
    });
  }

  Future<void> _submitProfile(
    SendNameEvent event,
    Emitter<CompleteProfileState> emit,
  ) async {
    emit(CompleteProfileLoading());

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await AuthLayer.completeUserProfile(
        userId: user.id,
        name: _name.trim(),
        email: user.email,
      );

      emit(CompleteProfileSuccess());
    } catch (e) {
      emit(CompleteProfileFailure(e.toString(), error: ''));
    }
  }
}
