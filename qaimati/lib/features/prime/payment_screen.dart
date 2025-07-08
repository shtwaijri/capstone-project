import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/features/prime/bloc/payment_bloc.dart';
import 'package:qaimati/features/prime/prime_service.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';

/// A stateless widget responsible for handling payment processing.
///
/// Displays the selected branch information and a credit card payment form.
/// Uses [PaymentBloc] for payment state management.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<PaymentBloc>();
          bloc.add(AmountEvent());
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 24,
                    children: [
                      BlocBuilder<PaymentBloc, PaymentState>(
                        builder: (context, state) {
                          if (state is SuccessState) {
                            return CreditCard(
                              config: paymentConfig(bloc.num),
                              onPaymentResult: (PaymentResponse value) async {
                                // Callback when payment result is received.
                                if (value.status == PaymentStatus.paid) {
                                  bloc.add(ActivatePrimeEvent());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationBarScreen(),
                                    ),
                                  );
                                  log("SuccessState");
                                } else if (value.status ==
                                    PaymentStatus.failed) {
                                  Navigator.pop(context);
                                  // Show snackbar on payment failure.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Payment failed. Please try again.',
                                        style: StyleText.regular16(context),
                                      ),
                                      backgroundColor: StyleColor.error,
                                    ),
                                  );
                                }
                              },
                            );
                          }
                          return Text("notheng");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Creates and returns a [PaymentConfig] object for the Moyasar payment plugin.
PaymentConfig paymentConfig(int amount) {
  return PaymentConfig(
    publishableApiKey: dotenv.env['moyasarKey'].toString(),
    amount: amount,
    description: 'order #1324',
  );
}
