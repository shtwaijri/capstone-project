import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_events.dart';
import 'package:qaimati/features/intro/bloc/onboarding_states.dart';
import 'package:qaimati/features/loading/loading_screen.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/empty_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding extends StatelessWidget {
  Onboarding({super.key});

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/svg/no_items.svg',
      'title': 'Quickly add and organize your shopping items in one plac',
    },
    {
      'image': 'assets/svg/no_member.svg',
      'title': 'Invite others, sync in real-time',
    },
    {
      'image': 'assets/svg/no_list.svg',
      'title': ' Manage receipts your for better tracking.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(totalPages: onboardingData.length),
      child: Builder(
        builder: (context) {
          final bloc = context.read<OnboardingBloc>();

          return Scaffold(
            body: PageView(
              controller: bloc.controller,
              onPageChanged: (value) {
                bloc.add(PageChangedEvent(value));
              },
              children: onboardingData.map((page) {
                return EmptyWidget(lable: page['title']!, img: page['image']!);
              }).toList(),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<OnboardingBloc, OnboardingStates>(
                builder: (context, state) {
                  return ButtomWidget(
                    onTab: () async {
                      if (bloc.state.pageIndex == onboardingData.length - 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seenOnboarding', true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoadingScreen()),
                        );
                      } else {
                        bloc.add(NextPressedEvent(bloc.state.pageIndex + 1));
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
