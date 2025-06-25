import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
/// empty widget using in empty screens while the is no data adding, and onboarding screen
/// 
/// the widget contains 4 parameters:
/// 
/// - lable: the title in screen
/// 
/// - img: the image in screen
/// 
/// - isOnboarding: if will used on onboarding, hint ont important | else need hint
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    this.isOnboarding = false,
    required this.lable,
    this.hint,
    required this.img,
  });
  final String img;
  final String lable;
  final bool isOnboarding;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(img),
            Text(
              lable,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24), textAlign: TextAlign.center,
            ),
            ?isOnboarding // if will used on onboarding, hint ont important | else need hint
                ? (hint != null ? Text(hint!) : SizedBox.shrink())
                : null,
          ],
        ),
      ),
    );
  }
}
