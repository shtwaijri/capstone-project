part of 'check_box_bloc.dart';

@immutable
sealed class CheckBoxEvent {}

class PressCheckBoxEvent extends CheckBoxEvent {
  final bool isChecked;

  PressCheckBoxEvent(this.isChecked);
}
