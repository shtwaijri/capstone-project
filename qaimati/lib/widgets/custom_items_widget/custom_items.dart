import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/custom_items_widget/bloc/check_box_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart'; // استيراد SubListBloc
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class CustomItems extends StatelessWidget {
  const CustomItems({
    super.key,
    required this.itemName,
    required this.numOfItems,
    required this.createdBy,
    required this.isImportant,
    required this.itemIndex, // جديد
    required this.isItemChecked, // جديد
  });
  final String numOfItems;
  final String itemName;
  final String createdBy;
  final bool isImportant;
  final int itemIndex; // مؤشر العنصر في القائمة
  final bool isItemChecked; // حالة الـ Checkbox من الـ Bloc

  @override
  Widget build(BuildContext context) {
    // لم نعد نحتاج BlocProvider هنا لأنه سيتم التحكم من SubListBloc الرئيسي
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: context.getWidth() * 0.05),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(
                  context.getWidth() * 0.015,
                  context.getHeight() * -0.008,
                ),
                // BlocBuilder لم يعد ضروريًا هنا لأنه isChecked يأتي مباشرة من الـ widget
                child: Checkbox(
                  side: BorderSide(color: StyleColor.green),
                  value: isItemChecked, // استخدم القيمة الممررة
                  onChanged: (value) {
                    // أرسل event لتحديث حالة الـ checkbox في SubListBloc
                    context.read<SubListBloc>().add(
                          ToggleItemCheckedEvent(
                            index: itemIndex,
                            isChecked: value!,
                          ),
                        );
                  },
                ),
              ),
              SizedBox(width: context.getWidth() * 0.01),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$numOfItems - ',
                        style: StyleText.bold16(context),
                      ),
                      Text(itemName, style: StyleText.bold16(context)),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'memberCreatedBy '.tr(),
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
              if (isImportant)
                Padding(
                  padding: EdgeInsets.only(left: context.getWidth() * 0.25),
                  child: Icon(Icons.priority_high, color: StyleColor.red),
                ),
            ],
          ),
        ),
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

 