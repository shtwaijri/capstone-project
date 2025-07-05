// completed_screen_state.dart
part of 'completed_screen_bloc.dart';

@immutable
sealed class CompletedScreenState {}

/// The initial state of the CompletedScreenBloc.

final class CompletedScreenInitial extends CompletedScreenState {}

/// State indicating that the CompletedScreenBloc is currently loading data.
class LoadingScreenState extends CompletedScreenState {}

/// State indicating that an error has occurred during a process in the CompletedScreenBloc.
class ErrorState extends CompletedScreenState {
  final String? message;

  ErrorState({required this.message});
}

/// State representing the successful retrieval and display of completed items data.
/// The `completedItemsMap` contains the organized data to be shown on the screen.
// ignore: must_be_immutable
class GetDataScreenState extends CompletedScreenState {
  Map<String, List<ItemModel>> completedItemsMap;
  GetDataScreenState({required this.completedItemsMap});
}
