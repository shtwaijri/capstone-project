part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class LoadProfileSettingEvent extends ProfileEvent {}

class ClickChangeLangEvent extends ProfileEvent {
  final bool isArabic;

  ClickChangeLangEvent({required this.isArabic});
}

class ClickChangeColorEvent extends ProfileEvent {
  final bool isDarkMode;

  ClickChangeColorEvent({required this.isDarkMode});
}

class UpdateNameEvent extends ProfileEvent {
  final String newName;

  UpdateNameEvent(this.newName);
}

class UpdateEmailEvent extends ProfileEvent {
  final String newEmail;

  UpdateEmailEvent(this.newEmail);
}
