// part of 'add_list_bloc.dart';

// @immutable
// sealed class AddListState {}

// final class AddListInitial extends AddListState {}

// final class UpdateState extends AddListState {}

// final class AddListLoading extends AddListState {}

// final class AddListLoaded extends AddListState {
//   final List<ListModel> lists;
//   AddListLoaded(this.lists);
// }

// final class AddListError extends AddListState {
//   final String message;
//   AddListError(this.message);
// }


part of 'add_list_bloc.dart';

@immutable
sealed class AddListState {}

final class AddListInitial extends AddListState {}

final class AddListLoading extends AddListState {}

final class AddListLoaded extends AddListState {
  final List<ListModel> lists;
  AddListLoaded(this.lists);
}

final class AddListError extends AddListState {
  final String message;
  AddListError(this.message);
}

// لو فعلاً تحتاج حالة لتغيير اللون
final class AddListColorUpdated extends AddListState {}



