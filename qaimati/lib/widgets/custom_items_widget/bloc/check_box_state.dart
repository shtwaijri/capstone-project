part of 'check_box_bloc.dart';

@immutable
sealed class CheckBoxState {}

final class CheckBoxInitial extends CheckBoxState {}

final class CheckboxValueState extends CheckBoxState {
  final bool isChecked;

  CheckboxValueState(this.isChecked);
}
