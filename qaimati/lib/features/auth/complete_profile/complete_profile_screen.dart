// ignore_for_file: dead_code

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/complete_profile/bloc/complete_profile_bloc.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompleteProfileBloc(),
      child: Scaffold(
        appBar: AppBarWidget(
          title: tr('CompleteTitle'),
          showActions: true,
          showSearchBar: false,
          showBackButton: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.getWidth() * 0.05,
            vertical: context.getHeight() * 0.02,
          ),
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
            //without rebuilding the widget, we use listner to handle the navigation
            listener: (context, state) {
              if (state is CompleteProfileSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigationBarScreen(),
                  ),
                  //we use it to remove all previous routes after complete the profile successfully
                  (route) => false,
                );
              } else if (state is CompleteProfileFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            //rebuild the ui based on the current state of the bloc
            builder: (context, state) {
              //to store the name
              String name = '';
              bool isLoading = false;
              String? errorMessage;

              if (state is CompleteProfileInitial) {
                name = state.name;
                errorMessage = state.nameError;
              } else if (state is CompleteProfileLoading) {
                isLoading = true;
              }

              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(tr('enterName'), style: StyleText.bold16(context)),
                    StyleSize.sizeH24,
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: tr('Yourname'),
                        labelStyle: StyleText.regular16(context),
                        border: const OutlineInputBorder(),
                        errorText: errorMessage,
                      ),
                      //when the user change the name send the updated name
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    StyleSize.sizeH16,
                    ButtomWidget(
                      onTab: isLoading
                          ? null // disable the button when loading
                          : () {
                              // when the button pressed, send the name
                              context.read<CompleteProfileBloc>().add(
                                SendNameEvent(name: name),
                              );
                            },
                      textElevatedButton: isLoading
                          ? ""
                          : tr('Continue'), // Show "Continue" when not loading
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
