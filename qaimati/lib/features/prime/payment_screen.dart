import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/features/prime/bloc/payment_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';

/// A stateless widget responsible for handling payment processing.
///
/// Displays the selected branch information and a credit card payment form.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.payment});
  final Function payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 24,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: CreditCard(
                    config: PaymentConfig(
                      publishableApiKey: dotenv.env['moyasarKey'].toString(),
                      amount: 999,
                      description: 'order #1324',
                    ),
                    onPaymentResult: payment,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
