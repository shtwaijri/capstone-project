// ignore_for_file: invalid_use_of_visible_for_testing_member, depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/models/app_user/app_user_model.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/models/list/list_model.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

part 'completed_screen_event.dart';
part 'completed_screen_state.dart';

class CompletedScreenBloc
    extends Bloc<CompletedScreenEvent, CompletedScreenState> {
  // The name of the currently active list
  String? listName;
  // The currently authenticated application user
  AppUserModel? user;

  // --- Dependency Injection via GetIt ---
  // Accesses the AppDatatLayer singleton through GetIt.
  final appGetit = GetIt.I.get<AppDatatLayer>();

  // Map to store completed items, grouped by list name
  Map<String, List<ItemModel>> completedItemsMap = {};

  // --- Stream Subscriptions ---
  // These subscriptions listen to real-time updates from the AppDatatLayer.
  StreamSubscription<List<ItemModel>>? _itemsSubscription;
  StreamSubscription<List<ListModel>>? _listsSubscription;

  CompletedScreenBloc() : super(CompletedScreenInitial()) {
    // Initial event to kick off the process when the screen is first loaded.
    on<LoadCompletedScreen>((event, emit) async {
      await initializeUserAndStreams();
      // Initializes user data and sets up data streams.
      // Data updates will subsequently be handled by `DataUpdatedEvent`.
    });

    // Event handler for when data in AppDatatLayer (items & lists)
    // This ensures UI is refreshed with the latest data.
    on<DataUpdatedEvent>((event, emit) async {
      emit(
        LoadingScreenState(),
      ); // Show loading indicator while data is refreshed
      await _loadCompletedItemsForLists(); // Reload completed items map
    });
  }

  /// Initializes the user object and sets up real-time stream listeners from `AppDatatLayer`.
  /// This is critical for fetching user data and enabling real-time updates.
  Future<void> initializeUserAndStreams() async {
    try {
      user = await fetchUserById(); // Fetch the authenticated user's details.
      if (user == null) {
        emit(ErrorState(message: "User not found."));
        return;
      }

      // Initialize the data streams in the AppDatatLayer for the fetched user.
      appGetit.initStreamsf(user!.userId);

      // Subscribe to the AppDatatLayer's items stream.
      // This BLoC acts as a listener for item updates from the AppDatatLayer.
      _itemsSubscription = appGetit.allItemsStream.listen(
        (items) {
          // When items update, trigger a DataUpdatedEvent to reload all necessary data.
          add(DataUpdatedEvent());
        },
        onError: (error) {
          emit(
            ErrorState(message: "Failed to load items: $error"),
          ); // Emit error state.
        },
      );

      // Subscribe to the AppDatatLayer's lists stream.
      // This BLoC acts as a listener for list updates from the AppDatatLayer.
      _listsSubscription = appGetit.allListsStream.listen(
        (lists) {
          // When lists update, trigger a DataUpdatedEvent to reload all necessary data.
          add(DataUpdatedEvent());
        },
        onError: (error) {
          emit(
            ErrorState(message: "Failed to load lists: $error"),
          ); // Emit error state.
        },
      );
    } catch (e) {
      emit(ErrorState(message: "Failed to initialize data streams: $e"));
    }
  }

  /// Loads completed items data for the "Completed Items" screen.
  /// This method is called when `DataUpdatedEvent` is received, ensuring it uses
  /// the latest data available in `AppDatatLayer`.
  Future<void> _loadCompletedItemsForLists() async {
    try {
      // Access the completed items map directly from AppDatatLayer,
      // which should now be populated by the stream updates.
      completedItemsMap = appGetit.allCompletedItemsByListName;

      // Emit a specific state for the completed items screen with the loaded data.
      emit(GetDataScreenState(completedItemsMap: completedItemsMap));
    } catch (e) {
      // Handle errors during loading completed items.
      emit(
        ErrorState(message: "Failed to load completed items for screen: $e"),
      );
    }
  }

  /// Overrides the `close` method from `Bloc` to clean up resources when the BLoC is closed.
  @override
  Future<void> close() {
    // Cancel the BLoC's own subscriptions to the AppDatatLayer's streams.
    _itemsSubscription?.cancel();
    _listsSubscription?.cancel();
    appGetit.dispose(); // Close StreamControllers in AppDatatLayer
    return super.close();
  }
}
