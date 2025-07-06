part of 'invite_bloc.dart';

@immutable
sealed class InviteState {}

class InviteInitial extends InviteState {}

class InviteLoadingState extends InviteState {}

class InviteLoadedState extends InviteState {
  final List<InviteModel> invites;
  InviteLoadedState(this.invites);
}

class InviteErrorState extends InviteState {
  final String errorMessage;
  InviteErrorState(this.errorMessage);
}
