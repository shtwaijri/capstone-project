import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/features/Lists/widgets/color_widget.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
/// Widget to select a color for a list, on click it will change the selected color.

class SelectColor extends StatelessWidget {
  const SelectColor({super.key, this.selected, this.onTapSelect});
  final int? selected;
  final Function(int)? onTapSelect;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text('listAddAction'.tr(), style: StyleText.bold12(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (onTapSelect != null) {
                  onTapSelect!(1);
                }
              },
              child: ColorsWidget(
                color: StyleColor.green,
                isSelected: selected == 1 ? true : false,
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (onTapSelect != null) {
                  onTapSelect!(2);
                }
              },
              child: ColorsWidget(
                color: StyleColor.yallow,
                isSelected: selected == 2 ? true : false,
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (onTapSelect != null) {
                  onTapSelect!(3);
                }
              },
              child: ColorsWidget(
                color: StyleColor.red,
                isSelected: selected == 3 ? true : false,
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (onTapSelect != null) {
                  onTapSelect!(4);
                }
              },
              child: ColorsWidget(
                color: StyleColor.orange,
                isSelected: selected == 4 ? true : false,
              ),
            ),
            InkWell(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (onTapSelect != null) {
                  onTapSelect!(5);
                }
              },
              child: ColorsWidget(
                color: StyleColor.blue,
                isSelected: selected == 5 ? true : false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
