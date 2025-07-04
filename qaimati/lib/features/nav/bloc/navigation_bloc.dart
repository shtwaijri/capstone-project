import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:qaimati/features/Lists/lists_screen.dart';
import 'package:qaimati/features/Lists/lists_screen/lists_screen.dart';
import 'package:qaimati/features/expenses/screens/expenses_screen.dart';
import 'package:qaimati/features/profile/profile_screen.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

/// Manages navigation state by handling navigation item selection events.
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final List<Widget> screens = [ListsScreen(), ExpensesScreen(), ListsScreen()];
  NavigationBloc() : super(NavigationBarState(0)) {
    on<NavigationEvent>((event, emit) {});
    on<NavigationItemSelected>((event, emit)async {
      final  user=  await fetchUserById();
    OneSignal.login(user!.userId);
      emit(NavigationBarState(event.index));
    });
  }
}
