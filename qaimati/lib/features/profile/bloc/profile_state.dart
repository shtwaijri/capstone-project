part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final String name;
  final String email;
  final bool isArabicState;
  final bool isDarkModeState;

  ProfileLoadedState({
    required this.isArabicState,
    required this.isDarkModeState,
    required this.name,
    required this.email,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdated extends ProfileState {}
