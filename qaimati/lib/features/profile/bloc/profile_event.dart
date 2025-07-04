part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class UpdateNameEvent extends ProfileEvent {
  final String newName;

  UpdateNameEvent(this.newName);
}

class UpdateEmailEvent extends ProfileEvent {
  final String newEmail;

  UpdateEmailEvent(this.newEmail);
}

class LoadProfileEvent extends ProfileEvent {}
