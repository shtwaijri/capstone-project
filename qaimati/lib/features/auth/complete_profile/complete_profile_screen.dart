// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/auth/complete_profile/bloc/complete_profile_bloc.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompleteProfileBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Complete your profile')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
            listener: (context, state) {
              if (state is CompleteProfileSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigationBarScreen(),
                  ),
                  (route) => false,
                );
              } else if (state is CompleteProfileFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              final bloc = context.read<CompleteProfileBloc>();
              String name = '';
              bool isLoading = false;
              String? errorMessage;

              if (state is CompleteProfileInitial) {
                name = state.name;
                errorMessage = state.nameError;
              }

              return Form(
                child: Column(
                  children: [
                    const Text(
                      'Please enter your name to complete your profile',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: 'Your name',
                        border: const OutlineInputBorder(),
                        errorText: errorMessage,
                      ),
                      onChanged: (value) {
                        bloc.add(AddNameEvent(value));
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              bloc.add(SendNameEvent());
                            },
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Continue'),
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
