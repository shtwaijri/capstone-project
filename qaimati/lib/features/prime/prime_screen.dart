import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';

class PrimeScreen extends StatelessWidget {
  const PrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: tr('Subspriction'),
        showActions: true,
        showSearchBar: false,
      ),

      body: Column(
        children: [
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.25,

                child: Image.asset("assets/image/qaimaty-logo.png"),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.0005),

              Text(
                tr("Qaiamtiprime"),
                style: StyleText.bold24(
                  context,
                ).copyWith(color: StyleColor.green),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),

                Icon(
                  CupertinoIcons.star_fill,
                  color: StyleColor.green,
                  size: 28,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Expanded(
                  child: Text(
                    tr("primeDescribe"),
                    style: StyleText.bold16(context),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ButtomWidget(onTab: () {}, textElevatedButton: tr('pay')),
        ],
      ),
    );
  }
}
// class PrimeScreen extends StatelessWidget {
//   const PrimeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.5),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             height: 56,
//             alignment: Alignment.center,
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.vertical(
//                 top: Radius.circular(25),
//               ),
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Text(
//               tr('Subspriction'),
//               style: StyleText.bold24(
//                 context,
//               ).copyWith(color: StyleColor.green),
//             ),
//           ),

//           const SizedBox(height: 10),

//           // باقي محتوى الصفحة
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.08,
//                 width: MediaQuery.of(context).size.width * 0.25,
//                 child: Image.asset("assets/image/qaimaty-logo.png"),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 tr("Qaiamtiprime"),
//                 style: StyleText.bold24(
//                   context,
//                 ).copyWith(color: StyleColor.green),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           Align(
//             alignment: Alignment.centerRight,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     CupertinoIcons.star_fill,
//                     color: StyleColor.green,
//                     size: 28,
//                   ),
//                   SizedBox(width: MediaQuery.of(context).size.width * 0.05),
//                   Expanded(
//                     child: Text(
//                       "مع اشتراك برايم، يمكنك رفع أكثر من 3 فواتير ومتابعة جميع مصاريفك بسهولة. الاشتراك يتيح لك الوصول\nإلى مزايا إضافية تساعدك في تنظيم قوائم التسوّق\n والمصاريف بطريقة أفضل.",
//                       style: StyleText.regular16(context),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 20),

//           ButtomWidget(onTab: () {}, textElevatedButton: tr('Pay')),
//         ],
//       ),
//     );
//   }
// }
