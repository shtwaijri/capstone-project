import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/expenses/bloc/receipt/receipt_bloc.dart';
import 'package:qaimati/features/expenses/widgets/upload_receipt_widget.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/Text_Field_widget.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';

/// Screen to handle receipt image upload and input for store name and total amount.
/// Uses [ReceiptBloc] for state management.
class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({
    super.key,
    this.storeName,
    this.totalAmount,
    this.imageUrl,
    this.receiptId,
  });
  final String? storeName;
  final String? totalAmount;
  final String? imageUrl;
  final String? receiptId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReceiptBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<ReceiptBloc>();
          return Scaffold(
            // Custom app bar widget.
            appBar: AppBarWidget(
              title: 'receipt'.tr(),
              showActions: false,
              showSearchBar: false,
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<ReceiptBloc, ReceiptState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    // Show loading spinner when processing
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is SuccessState) {
                    // If receipt image upload succeeded, show the image and form fields
                    return SingleChildScrollView(
                      child: Column(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.file(
                            state.image,
                            width: context.getWidth(),
                            height: context.getHeight() * 0.4,
                            fit: BoxFit.cover,
                          ),
                          // Label and text field for store name
                          Text(
                            'receiptStore'.tr(),
                            style: StyleText.bold16(context),
                          ),
                          TextFieldWidget(
                            controller: bloc.storController,
                            textHint: 'receiptEnterStore'.tr(),
                          ),
                          // Label and text field for total amount
                          Text(
                            'receiptTotalLabel'.tr(),
                            style: StyleText.bold16(context),
                          ),
                          TextFieldWidget(
                            controller: bloc.totalController,
                            textHint: 'receiptEnterTotal'.tr(),
                          ),
                          // Buttons for cancel and submit actions
                          DualActionButtonWidget(
                            onPrimaryTap: () {
                              Navigator.pop(context);
                            },
                            primaryLabel: 'commonCancel'.tr(),
                            onSecondaryTap: () {
                              bloc.add(SaveReceiptEvent());
                              Navigator.pop(context);
                            },
                            secondaryLabel: 'receiptSubmit'.tr(),
                            isDelete: false,
                            isCancel: true,
                          ),
                        ],
                      ),
                    );
                  }
                  // Default UI (initial or other states):
                  // Show upload receipt prompt and form fields
                  return SingleChildScrollView(
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tappable widget to trigger image upload
                        InkWell(
                          onTap: () {
                            bloc.add(UplaodReceiptEvent());
                          },
                          child: UploadReceiptWidget(),
                        ),
                        Text(
                          'receiptStore'.tr(),
                          style: StyleText.bold16(context),
                        ),
                        TextFieldWidget(
                          controller: bloc.storController,
                          textHint: 'receiptEnterStore'.tr(),
                        ),
                        Text(
                          'receiptTotalLabel'.tr(),
                          style: StyleText.bold16(context),
                        ),
                        TextFieldWidget(
                          controller: bloc.totalController,
                          textHint: 'receiptEnterTotal'.tr(),
                        ),
                        // Buttons for cancel and submit actions
                        DualActionButtonWidget(
                          onPrimaryTap: () {
                            Navigator.pop(context);
                          },
                          primaryLabel: 'commonCancel'.tr(),
                          onSecondaryTap: () {},
                          secondaryLabel: 'receiptSubmit'.tr(),
                          isDelete: false,
                          isCancel: true,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
