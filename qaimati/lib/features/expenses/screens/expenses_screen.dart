import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/features/expenses/widgets/receipt_widget.dart';
import 'package:qaimati/features/expenses/widgets/spending_widget.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/floating_button.dart';

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
            SpendingWidget(money: 100),
            Container(color: StyleColor.gray, height: 3),
            ListTile(
              leading: Icon(Icons.receipt, size: 30, color: StyleColor.green),
              title: Text(
                'receiptSummary'.tr(),
                style: StyleText.bold16(context),
              ),
            ),
            ReceiptWidget(storName: 'hi', total: 'kk'),
          ],
        ),
      ),
      floatingActionButton: FloatingButton(onpressed: () {}),
    );
  }
}
