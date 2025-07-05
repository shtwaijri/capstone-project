// completed_screen_state.dart
part of 'completed_screen_bloc.dart';

@immutable
sealed class CompletedScreenState {}

final class CompletedScreenInitial extends CompletedScreenState {}

class LoadingScreenState extends CompletedScreenState {}

class ErrorState extends CompletedScreenState {
  final String? message;

  ErrorState({required this.message});
}

// ignore: must_be_immutable
class GetDataScreenState extends CompletedScreenState {
  Map<String, List<ItemModel>> completedItemsMap;
  GetDataScreenState({required this.completedItemsMap});
}