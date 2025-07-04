import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/features/prime/bloc/payment_bloc.dart';
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
                // Show currently selected branch using BranchWidget.
                // BranchWidget(branch: bloc.branchGetIt.branchName()),
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    if (state is SuccessState) {
                      return CreditCard(
                        config: paymentConfig(bloc.num),
                        onPaymentResult: (PaymentResponse value) async {
                          // Callback when payment result is received.
                          if (value.status == PaymentStatus.paid) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NavigationBarScreen(),
                              ),
                            );
                            print("SuccessState");
                          } else if (value.status == PaymentStatus.failed) {
                            Navigator.pop(context);
                            // Show snackbar on payment failure.
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Payment failed. Please try again.',
                                  style: StyleText.regular16Error(context),
                                ),
                                backgroundColor: StyleColor.white,
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
  }
}

/// Creates and returns a [PaymentConfig] object for the Moyasar payment plugin.
PaymentConfig paymentConfig(int amount) {
  return PaymentConfig(
    publishableApiKey: '',
    amount: amount,
    description: 'order #1324',
  );
}
