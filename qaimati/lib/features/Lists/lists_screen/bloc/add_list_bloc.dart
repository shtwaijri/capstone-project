import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

part 'add_list_event.dart';
part 'add_list_state.dart';

class AddListBloc extends Bloc<AddListEvent, AddListState> {
  int selectColor = 1;
  final appGetit = GetIt.I.get<AppDatatLayer>();
  AppUserModel? user;

  var list;
  changeColor(int index) {
    // this function to change color when user click on any color, i will use the select color to store it in datebase
    selectColor = index;
    // ignore: invalid_use_of_visible_for_testing_member
    emit(AddListColorUpdated());
  }

  AddListBloc() : super(AddListInitial()) {
    // on<AddListEvent>((event, emit) {});
    on<LoadListsEvent>(loadListsMethod);
    on<LoadMemberListsEvent>(loadMemberListsMethod);
    on<CreateListEvent>(addListMethod);
    on<UpdateListEvent>(updateListMethod);
    on<DeleteListEvent>(deleteListMethod);
  }

  FutureOr<void> addListMethod(
    CreateListEvent event,
    Emitter<AddListState> emit,
  ) async {
    emit(AddListLoading());

    try {
      final newList = ListModel(
        listId: '',
        name: event.name,
        color: event.color,
        createdAt: event.createdAt,
      );

      await appGetit.createNewList(newList);
      await appGetit.loadAdminLists();
      emit(AddListLoaded(appGetit.lists));
    } catch (e) {
      emit(AddListError(e.toString()));
    }
  }

  FutureOr<void> updateListMethod(
    UpdateListEvent event,
    Emitter<AddListState> emit,
  ) async {
    emit(AddListLoading());

    try {
      print(
        "🛠 Updating list with: ${event.list.name}, color=${event.list.color}",
      );

      final updatedList = ListModel(
        listId: event.list.listId,
        name: event.list.name,
        color: selectColor,
        createdAt: event.list.createdAt,
      );

      await appGetit.submitListUpdate(updatedList);
      await appGetit.loadAdminLists();

      emit(AddListLoaded(appGetit.lists));
    } catch (e) {
      emit(AddListError(e.toString()));
    }
  }

  FutureOr<void> deleteListMethod(
    DeleteListEvent event,
    Emitter<AddListState> emit,
  ) async {
    emit(AddListLoading());

    try {
      await appGetit.confirmDeleteList(event.listId);

      await appGetit.loadAdminLists();

      emit(AddListLoaded(appGetit.lists));
    } catch (e) {
      emit(AddListError(e.toString()));
    }
  }

  FutureOr<void> loadListsMethod(
    LoadListsEvent event,
    Emitter<AddListState> emit,
  ) async {
    try {
      user = await fetchUserById(); // Fetch the authenticated user's details.

      emit(AddListLoading());
      appGetit.initStreamsf(user!.userId);
      await appGetit.loadAdminLists();
      emit(AddListLoaded(appGetit.lists));
    } catch (e) {
      emit(AddListError(e.toString()));
    }
  }

  FutureOr<void> loadMemberListsMethod(
    LoadMemberListsEvent event,
    Emitter<AddListState> emit,
  ) async {
    try {
      emit(AddListLoading());
      await appGetit.loadMemberLists();
      emit(AddListLoaded(appGetit.lists));
    } catch (e) {
      emit(AddListError(e.toString()));
    }
  }
}
