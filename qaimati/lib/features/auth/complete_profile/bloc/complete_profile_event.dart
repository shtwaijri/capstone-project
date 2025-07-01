part of 'complete_profile_bloc.dart';

@immutable
sealed class CompleteProfileEvent {}

class AddNameEvent extends CompleteProfileEvent {
  final String name;

  AddNameEvent(this.name);
}

class SendNameEvent extends CompleteProfileEvent {}
