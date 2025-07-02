part of 'complete_profile_bloc.dart';

@immutable
sealed class CompleteProfileState {}

final class CompleteProfileInitial extends CompleteProfileState {
  final String name;
  final String? nameError;

  CompleteProfileInitial({this.name = '', this.nameError});
}

final class CompleteProfileLoading extends CompleteProfileState {}

final class CompleteProfileSuccess extends CompleteProfileState {}

final class CompleteProfileFailure extends CompleteProfileState {
  final String error;

  CompleteProfileFailure(String string, {required this.error});
}
