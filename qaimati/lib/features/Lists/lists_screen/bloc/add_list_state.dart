part of 'add_list_bloc.dart';

@immutable
sealed class AddListState {}

final class AddListInitial extends AddListState {}

final class UpdateState extends AddListState {}
