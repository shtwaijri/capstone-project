// import 'package:bloc/bloc.dart';
// import 'package:essert_coffee/features/cart/screens/cart_screen.dart';
// import 'package:essert_coffee/features/menu/screens/menu_screen.dart';
// import 'package:essert_coffee/features/more/screens/more_screen.dart';
// import 'package:essert_coffee/features/order/screens/order_screen.dart';
// import 'package:flutter/material.dart';

// part 'navigation_event.dart';
// part 'navigation_state.dart';

// /// Manages navigation state by handling navigation item selection events.
// class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
//   final List<Widget> screens = [
//     MenuScreen(),
//     CartScreen(),
//     OrderScreen(),
//     MoreScreen(),
//   ];
//   NavigationBloc() : super(NavigationBarState(0)) {
//     on<NavigationEvent>((event, emit) {});
//     on<NavigationItemSelected>((event, emit) {
//       emit(NavigationBarState(event.index));
//     });
//   }
// }
