part of 'navigation_bloc.dart';

@immutable
sealed class NavigationState {}

final class NavigationBarState extends NavigationState {
  final int selectedIndex;
  NavigationBarState(this.selectedIndex);
}
