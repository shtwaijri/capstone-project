import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moyasar/moyasar.dart';

import 'package:qaimati/widgets/app_bar_widget.dart';

/// A stateless widget responsible for handling payment processing.
///
/// Displays the selected branch information and a credit card payment form.
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.payment});
  final Function payment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: tr("SubscriptionPay"),
        showActions: false,
        showSearchBar: false,
        showBackButton: true,
      ),
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
