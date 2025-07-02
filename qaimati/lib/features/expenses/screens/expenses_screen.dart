import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/expenses/bloc/expenses/expenses_bloc.dart';
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
    return BlocProvider(
      create: (context) => ExpensesBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ExpensesBloc>()..add(LoadingReceiptEvent());
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
                    leading: Icon(
                      Icons.receipt,
                      size: 30,
                      color: StyleColor.green,
                    ),
                    title: Text(
                      'receiptSummary'.tr(),
                      style: StyleText.bold16(context),
                    ),
                  ),

                  // A receipt summary widget with placeholder data
                  BlocBuilder<ExpensesBloc, ExpensesState>(
                    builder: (context, state) {
                      log("Current state: $state");
                      if (state is LoadingState) {
                        // Show loading spinner when processing
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is LoadingState) {
                        // Show loading spinner when processing
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is SuccessState && state.receipt.isNotEmpty) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: state.receipt.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  SizedBox(height: 16),
                                  InkWell(
                                    onTap: () {
                                      //   showModalBottomSheet(
                                      //     context: context,
                                      //     backgroundColor: StyleColor.grey,
                                      //     shape: const RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.vertical(
                                      //         top: Radius.circular(20),
                                      //       ),
                                      //     ),
                                      //     isScrollControlled: true,
                                      //     builder: (context) {
                                      //       return BlocProvider.value(
                                      //         value: bloc,
                                      //         child: TaskDetailsSheet(
                                      //           task: state.tasks[index],
                                      //         ),
                                      //       );
                                      //     },
                                      //   );
                                      // },
                                    },
                                    child: ReceiptWidget(
                                      storName: state.receipt[index].supplier,
                                      total: state.receipt[index].totalAmount
                                          .toString(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return Text(
                        "receiptNoReceipts".tr(),
                        style: StyleText.bold24(context),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
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
        },
      ),
    );
  }
}
