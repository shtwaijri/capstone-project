import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/features/expenses/screens/receipt_screen.dart';
import 'package:qaimati/features/expenses/widgets/receipt_widget.dart';
import 'package:qaimati/features/expenses/widgets/spending_widget.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/floating_button.dart';

/// Screen showing expenses overview including spending summary and receipts.
///
/// Includes a floating button to navigate to the ReceiptScreen for adding receipts.
class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'receiptExpenses'.tr(),
        showActions: false,
        showSearchBar: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            // Widget showing total spending amount
            SpendingWidget(money: 100),
            // Thin gray divider line
            Container(color: StyleColor.gray, height: 3),
            // Header row with icon and localized text "Receipt Summary"
            ListTile(
              leading: Icon(Icons.receipt, size: 30, color: StyleColor.green),
              title: Text(
                'receiptSummary'.tr(),
                style: StyleText.bold16(context),
              ),
            ),
            // A receipt summary widget with placeholder data
            ReceiptWidget(storName: 'hi', total: 'kk'),
          ],
        ),
      ),
      // Floating button to navigate to ReceiptScreen to add a new receipt
      floatingActionButton: FloatingButton(
        onpressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ReceiptScreen()),
          );
        },
      ),
    );
  }
}
