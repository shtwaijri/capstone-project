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
// ============================================ add list state

final class AddListCreating extends AddListState {}

final class AddListCreated extends AddListState {
  final ListModel newList;
  AddListCreated(this.newList);
}

final class AddListCreateError extends AddListState {
  final String message;
  AddListCreateError(this.message);
}
// ============================================ add list state

final class AddListColorUpdated extends AddListState {}
