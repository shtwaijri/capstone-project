import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/dual_action_button_widget.dart';
import 'package:qaimati/widgets/loading_widget.dart';
import 'package:qaimati/widgets/text_field_widget.dart';

/// A widget for updating a receipt, including an image, store name,
/// total amount fields, and action buttons for update and delete.
class UpdateWigdet extends StatelessWidget {
  UpdateWigdet({
    super.key,
    this.imageUrl,
    this.delete,
    this.update,
    required this.storeController,
    required this.totalController,
  });

  /// Controller for the store name input field
  final TextEditingController storeController;

  /// Controller for the total amount input field
  final TextEditingController totalController;

  /// Optional image URL for the receipt preview
  final String? imageUrl;

  /// Callback when the delete button is pressed
  final Function()? delete;

  /// Callback when the update button is pressed
  final Function()? update;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.getHeight() * 0.7,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display receipt image or fallback if it fails
            Image.network(
              imageUrl!,
              width: context.getWidth(),
              height: context.getHeight() * 0.4,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text('imageLoadFailed'.tr());
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return LoadingWidget();
              },
            ),
            Text('receiptStore'.tr(), style: StyleText.bold16(context)),
            TextFieldWidget(
              controller: storeController,
              textHint: 'receiptEnterTotal'.tr(),
            ),

            Text('receiptTotalLabel'.tr(), style: StyleText.bold16(context)),

            TextFieldWidget(
              controller: totalController,
              textHint: 'receiptEnterTotal'.tr(),
            ),
            DualActionButtonWidget(
              onPrimaryTap: update,
              primaryLabel: 'receiptUpdate'.tr(),
              onSecondaryTap: delete,
              secondaryLabel: 'receiptDelete'.tr(),
              isDelete: true,
              isCancel: false,
            ),
          ],
        ),
      ),
    );
  }
}
