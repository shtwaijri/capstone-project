part of 'navigation_bloc.dart';

@immutable
sealed class NavigationEvent {}

class NavigationItemSelected extends NavigationEvent {
  final int index;
  NavigationItemSelected(this.index);
}
