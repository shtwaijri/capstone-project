import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/expenses/bloc/expenses/expenses_bloc.dart';
import 'package:qaimati/features/expenses/screens/receipt_screen.dart';
import 'package:qaimati/features/expenses/widgets/calendar_widget.dart';
import 'package:qaimati/features/expenses/widgets/receipt_widget.dart';
import 'package:qaimati/features/expenses/widgets/spending_widget.dart';
import 'package:qaimati/features/expenses/widgets/update_wigdet.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_shimmer_effect.dart';
import 'package:qaimati/widgets/floating_button.dart';
import 'package:qaimati/widgets/loading_widget.dart';

/// Screen showing expenses overview including spending summary and receipts.
///
/// Includes a floating button to navigate to the ReceiptScreen for adding receipts.
class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpensesBloc()
        ..add(
          MonthChangedEvent(
            year: DateTime.now().year,
            month: DateTime.now().month,
          ),
        ),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ExpensesBloc>();
          return BlocListener<ExpensesBloc, ExpensesState>(
            listener: (context, state) async {
              if (state is IsPremiumiState) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReceiptScreen()),
                );

                if (result == true) {
                  final bloc = context.read<ExpensesBloc>();
                  bloc.add(
                    MonthChangedEvent(
                      year: bloc.displayedDate.year,
                      month: bloc.displayedDate.month,
                    ),
                  );
                }
              }
              if (state is IsNotPremiumiState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBarWidget(
                title: 'receiptExpenses'.tr(),
                showActions: false,
                showSearchBar: false,
                showBackButton: false,
              ),

              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<ExpensesBloc, ExpensesState>(
                  buildWhen: (previous, current) {
                    if (previous is SuccessState &&
                        (current is IsNotPremiumiState)) {
                      return false;
                    }

                    return true;
                  },
                  builder: (context, state) {
                    return Column(
                      spacing: 16,
                      children: [
                        CalendarWidget(
                          formattedDate: DateFormat(
                            'MMMM yyyy',
                          ).format(bloc.displayedDate),
                          onDecrementMonth: () {
                            final previousMonth = DateTime(
                              bloc.displayedDate.year,
                              bloc.displayedDate.month - 1,
                            );

                            bloc.add(SetDateEvent(previousMonth));

                            bloc.add(
                              MonthChangedEvent(
                                year: previousMonth.year,
                                month: previousMonth.month,
                              ),
                            );
                          },
                          onIncrementMonth: () {
                            final nextMonth = DateTime(
                              bloc.displayedDate.year,
                              bloc.displayedDate.month + 1,
                            );

                            bloc.add(SetDateEvent(nextMonth));

                            bloc.add(
                              MonthChangedEvent(
                                year: nextMonth.year,
                                month: nextMonth.month,
                              ),
                            );
                          },
                        ),
                        // Widget showing total spending amount
                        SpendingWidget(money: bloc.total),
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
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              log("Current state: $state");
                              if (state is LoadingState) {
                                // Show loading spinner when processing
                                return SingleChildScrollView(
                                  child: CustomShimmerEffect(isItem: false),
                                );
                              }
                              if (state is ErrorState) {
                                // Show loading spinner when processing
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: StyleText.regular16Error(context),
                                  ),
                                );
                              }
                              if (state is SuccessState &&
                                  state.receipt.isNotEmpty) {
                                return ListView.builder(
                                  itemCount: state.receipt.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 16),
                                        InkWell(
                                          onTap: () {
                                            bloc.storeController.text =
                                                state.receipt[index].supplier;
                                            bloc.totalController.text = state
                                                .receipt[index]
                                                .totalAmount
                                                .toString();
                                            showModalBottomSheet(
                                              showDragHandle: true,
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom, // Adds space for keyboard
                                                  ),
                                                  child: BlocProvider.value(
                                                    value: bloc,
                                                    child: UpdateWigdet(
                                                      imageUrl: state
                                                          .receipt[index]
                                                          .receiptFileUrl,
                                                      delete: () {
                                                        bloc.add(
                                                          DeleteReceiptEvent(
                                                            state
                                                                .receipt[index]
                                                                .receiptId!,
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      update: () {
                                                        bloc.add(
                                                          UpdateReceiptEvent(
                                                            state
                                                                .receipt[index]
                                                                .receiptId!,
                                                            {
                                                              'supplier': bloc
                                                                  .storeController
                                                                  .text,
                                                              'total_amount':
                                                                  double.tryParse(
                                                                    bloc
                                                                        .totalController
                                                                        .text,
                                                                  ) ??
                                                                  0.0,
                                                            },
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      storeController:
                                                          bloc.storeController,
                                                      totalController:
                                                          bloc.totalController,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            // bloc.add(
                                            //   MonthChangedEvent(
                                            //     year: bloc.displayedDate.year,
                                            //     month: bloc.displayedDate.month,
                                            //   ),
                                            // );
                                          },

                                          child: ReceiptWidget(
                                            storName:
                                                state.receipt[index].supplier,
                                            total: state
                                                .receipt[index]
                                                .totalAmount
                                                .toString(),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                              return Text(
                                "receiptNoReceipts".tr(),
                                style: StyleText.bold16(context),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Floating button to navigate to ReceiptScreen to add a new receipt
              floatingActionButton: FloatingButton(
                onpressed: () async {
                  // try {
                  // await ReceiptSupabase().checkAddReceiptEligibility();
                  bloc.add(CheckPirEvent());

                  //     final result = await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => ReceiptScreen()),
                  //     );

                  //     if (result == true) {
                  //       final bloc = context.read<ExpensesBloc>();
                  //       bloc.add(
                  //         MonthChangedEvent(
                  //           year: bloc.displayedDate.year,
                  //           month: bloc.displayedDate.month,
                  //         ),
                  //       );
                  //     }
                  //   } catch (e) {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: Text(
                  //           e.toString(),
                  //           style: TextStyle(color: Colors.white),
                  //         ),
                  //         backgroundColor: Colors.red,
                  //       ),
                  //     );
                  //   } 
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
