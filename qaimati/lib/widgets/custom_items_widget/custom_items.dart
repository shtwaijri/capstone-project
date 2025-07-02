// في ملف qaimati/widgets/custom_items_widget/custom_items.dart (المسار الصحيح)

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart'; // تأكد من المسار الصحيح للـ bloc

class CustomItems extends StatelessWidget {
  const CustomItems({
    super.key,
    required this.itemName,
    required this.numOfItems,
    required this.createdBy,
    required this.isImportant,
    required this.itemIndex,
    required this.isItemChecked,
    required this.itemId,
    this.isCheckboxEnabled = true,
    this.checkboxColor, // ⭐️ إضافة هذه الخاصية الجديدة
  });
  final String numOfItems;
  final String itemName;
  final String createdBy;
  final bool isImportant;
  final int itemIndex;
  final bool isItemChecked;
  final String itemId;
  final bool isCheckboxEnabled;
  final Color? checkboxColor; // ⭐️ تعريف الخاصية من نوع Color

  @override
  Widget build(BuildContext context) {
    // تحديد اللون الافتراضي (الأخضر) إذا لم يتم تمرير لون
    final Color actualCheckboxColor = checkboxColor ?? StyleColor.green;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.getWidth() * 0.05, right: context.getWidth() * 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(
                  context.getWidth() * 0.015,
                  context.getHeight() * -0.008,
                ),
                child: Checkbox(
                  // ⭐️ استخدام اللون الفعلي لـ BorderSide
                  side: BorderSide(color: actualCheckboxColor),
                  value: isItemChecked,
                  onChanged: isCheckboxEnabled
                      ? (value) {
                          context.read<SubListBloc>().add(
                                ToggleItemCheckedEvent(
                                   
                                  isChecked: value!,
                                  itemId: itemId,
                                ),
                              );
                        }
                      : null, // إذا كان false، الـ Checkbox غير قابل للضغط
                  // ⭐️ استخدام اللون الفعلي لـ fillColor
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return actualCheckboxColor; // لون التعبئة عندما يكون محددًا
                      }
                      // لون التعبئة عندما يكون غير محدد. يمكن أن يكون شفافًا أو بلون فاتح من اللون الفعلي
                      // إذا كان غير مفعل (disabled)، فسيظهر لون رمادي افتراضي من Flutter ما لم نتحكم به.
                      // حاليًا، اللون الرمادي سيظهر تلقائيًا للـ disabled Checkbox.
                      // لضمان اللون الرمادي بالضبط عند disabled، قد نحتاج لـ states.contains(MaterialState.disabled)
                      // ولكن بما أننا نمرر اللون الرمادي من الخارج، فإن actualCheckboxColor ستكون رمادية.
                      return actualCheckboxColor.withOpacity(0.5); // لون خفيف للعنصر غير المحدد
                    },
                  ),
                  checkColor: Colors.white, // لون علامة الصح
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return actualCheckboxColor.withOpacity(0.1);
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return actualCheckboxColor.withOpacity(0.2);
                      }
                      return Colors.transparent;
                    },
                  ),
                ),
              ),
              SizedBox(width: context.getWidth() * 0.01),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$numOfItems - ', style: StyleText.bold16(context)),
                        Flexible(
                          child: Text(
                            itemName,
                            style: StyleText.bold16(context),
                          ),
                        ),
                        if (isImportant)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.priority_high, color: StyleColor.red),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        text: 'memberCreatedBy'.tr(),
                        style: StyleText.regular12(
                          context,
                        ).copyWith(fontSize: 10, color: StyleColor.gray),
                        children: [
                          TextSpan(
                            text: createdBy,
                            style: StyleText.bold12(
                              context,
                            ).copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4,),
        Divider(
          height: 0,
          color: StyleColor.gray,
          thickness: 1.01,
          indent: context.getWidth() * 0.04,
          endIndent: context.getWidth() * 0.17,
        ),
      ],
    );
  }
}