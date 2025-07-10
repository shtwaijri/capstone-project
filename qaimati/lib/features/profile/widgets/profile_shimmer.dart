import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class ProfileShimmerEffect extends StatelessWidget {
  const ProfileShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.getWidth();
    final height = context.getHeight();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.03),

          // اسم المستخدم
          FadeShimmer(
            height: 16,
            width: width * 0.4,
            radius: 8,
            baseColor: StyleColor.gray,
            highlightColor: StyleColor.graylight,
          ),

          SizedBox(height: height * 0.015),

          // الإيميل
          FadeShimmer(
            height: 16,
            width: width * 0.6,
            radius: 8,
            baseColor: StyleColor.gray,
            highlightColor: StyleColor.graylight,
          ),

          SizedBox(height: height * 0.04),

          // عنوان "الإعدادات"
          FadeShimmer(
            height: 18,
            width: width * 0.3,
            radius: 6,
            baseColor: StyleColor.gray,
            highlightColor: StyleColor.graylight,
          ),

          SizedBox(height: height * 0.03),

          // عناصر الإعدادات (لغة - ثيم - الاسم - الإيميل - برايم - تسجيل خروج)
          ...List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: FadeShimmer(
                height: 55,
                width: width * 0.9,
                radius: 12,
                baseColor: StyleColor.gray,
                highlightColor: StyleColor.graylight,
              ),
            );
          }),
        ],
      ),
    );
  }
}
