// completed_screen_event.dart
part of 'completed_screen_bloc.dart';

@immutable
sealed class CompletedScreenEvent {}

class LoadCompletedScreen extends CompletedScreenEvent {}

// Event to signal that data from AppDatatLayer streams has been updated
class DataUpdatedEvent extends CompletedScreenEvent {}