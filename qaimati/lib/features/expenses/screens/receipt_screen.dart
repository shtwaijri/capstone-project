import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/features/expenses/widgets/upload_receipt_widget.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/Text_Field_widget.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController storController = TextEditingController();
    final TextEditingController totalController = TextEditingController();
    return Scaffold(
      appBar: AppBarWidget(
        title: 'receipt'.tr(),
        showActions: false,
        showSearchBar: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UploadReceiptWidget(),
              Text('receiptStore'.tr(), style: StyleText.bold16(context)),
              TextFieldWidget(
                controller: storController,
                textHint: 'receiptEnterStore'.tr(),
              ),
              Text('receiptTotalLabel'.tr(), style: StyleText.bold16(context)),
              TextFieldWidget(
                controller: totalController,
                textHint: 'receiptEnterTotal'.tr(),
              ),
              DualActionButtonWidget(
                onPrimaryTap: () {},
                primaryLabel: 'commonCancel'.tr(),
                onSecondaryTap: () {},
                secondaryLabel: 'receiptSubmit'.tr(),
                isDelete: false,
                isCancel: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
