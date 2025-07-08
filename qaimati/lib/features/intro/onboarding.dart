import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/auth/auth_screen.dart';
import 'package:qaimati/features/intro/bloc/onboarding_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_events.dart';
import 'package:qaimati/features/intro/bloc/onboarding_states.dart';
import 'package:qaimati/features/intro/onboarding_info.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/empty_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  
final onboardingData = GetIt.instance<OnboardingInfo>().onboardingData;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: onboardingData.length),
      child: Builder(
        builder: (context) {
          final bloc = context.read<OnboardingBloc>();

          return Scaffold(
            body: PageView(
              controller: bloc.controller, // controlling the page view to change on press
              onPageChanged: (value) {
                bloc.add(PageChangedEvent(value));
              },
              children: onboardingData.map((page) {
                return EmptyWidget(lable: page['title']!, img: page['image']!); // take data from list of map named onboardingData
              }).toList(), // convert it to list (page view need list of widgets)
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<OnboardingBloc, OnboardingStates>(
                builder: (context, state) {
                  return ButtomWidget( // custom widget
                    onTab: () async {
                      if (bloc.state.pageIndex == onboardingData.length - 1) { // if its last page, go to next screen
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seenOnboarding', true); // cnage seenOnboarding to true (user has seen onboarding, so will not apearing again)

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => AuthScreen()),
                        );
                      } else {
                        bloc.add(NextPressedEvent(bloc.state.pageIndex + 1));  //pageIndex is the index fo the current page in pag view
                      }
                    },
                    textElevatedButton: 'Next',
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
