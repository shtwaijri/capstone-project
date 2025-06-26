import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_bloc.dart';
import 'package:qaimati/features/intro/bloc/onboarding_events.dart';
import 'package:qaimati/features/intro/bloc/onboarding_states.dart';
import 'package:qaimati/features/loading/loading_screen.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/empty_widget.dart';

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
    return Scaffold(
      body: BlocBuilder<OnboardingBloc, OnboardingStates>(
        builder: (context, state) {
          final bloc = context.read<OnboardingBloc>();

          return PageView(
            controller: bloc.controller,
            onPageChanged: (value) {
              bloc.add(PageChangedEvent(value));
            },
            children: onboardingData.map(
              (page) {
                return EmptyWidget(lable: page['title']!, img: page['image']!);
              },
            ).toList(), // cnvert to list becouse children[] must contain list (not map)
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ButtomWidget(
          onTab: () {
            final bloc = context.read<OnboardingBloc>();
            if (bloc.state.pageIndex == onboardingData.length - 1) {
              // if not last page go to next, if last page go to next screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen()),
              );
            } else {
              bloc.add(NextPressedEvent(bloc.state.pageIndex + 1));
            }
          },
          textElevatedButton: 'Next',
        ),
      ),
    );
  }
}
