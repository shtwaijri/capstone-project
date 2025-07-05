import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_events.dart';
import 'package:qaimati/features/intro/bloc/onboarding_states.dart';

class OnboardingBloc extends Bloc<OnboardingEvents, OnboardingStates> {
  final PageController controller = PageController();
  final int totalPages;

  OnboardingBloc({required this.totalPages}) : super(OnboardingStates()) {
    on<PageChangedEvent>((event, emit) {
      emit(OnboardingStates(pageIndex: event.newIndex)); 
    });

    on<NextPressedEvent>((event, emit) {
      final nextPage = state.pageIndex + 1;
      if (nextPage < totalPages) {
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        emit(OnboardingStates(pageIndex: nextPage));
      }
    });
  }
}
