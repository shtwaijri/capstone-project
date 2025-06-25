// import 'dart:async';
// import 'dart:developer';

// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:meta/meta.dart';
// import 'package:qaimati/layer_data/auth_layer.dart';

// part 'auth_event.dart';
// part 'auh_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController conpasswordController = TextEditingController();

//   final authGetit = GetIt.I.get<AuthLayer>();
//   AuthBloc() : super(AuthStateInit()) {
//     on<AuthEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//     on<SignUpEvent>(signupMethod);
//     on<LogInEvent>(loginMethod);
//   }

//   FutureOr<void> signupMethod(
//     SignUpEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     try {
//       log("signupMethod in bloc start");
//       await authGetit.signUp(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       log("signupMethod in bloc end SuccessState");

//       emit(SuccessState());
//     } catch (error) {
//       log("signupMethod in bloc end error $error");
//       emit(ErrorState(msg: error.toString()));
//     }
//   }

//   FutureOr<void> loginMethod(LogInEvent event, Emitter<AuthState> emit) async {
//     try {
//       log("loginMethod in bloc start");
//       await authGetit.login(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       log("loginMethod in bloc end SuccessState");

//       emit(SuccessState());
//     } catch (error) {
//       log("loginMethod in bloc end error $error");
//       emit(ErrorState(msg: error.toString()));
//     }
//   }
// }
