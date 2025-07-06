part of 'complete_profile_bloc.dart';

@immutable
sealed class CompleteProfileEvent {}

class SendNameEvent extends CompleteProfileEvent {
  final String name;

  SendNameEvent({required this.name});
}
