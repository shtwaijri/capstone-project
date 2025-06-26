import 'dart:developer';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/add_item_bootomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/complete_item_bottomsheet.dart';
import 'package:qaimati/features/sub_list/widgets/bootomsheet/update_delete_item%20bottom_sheet.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/helper/onesignal_helper.dart';
import 'package:qaimati/widgets/floating_button.dart';

class SubListScreen extends StatelessWidget {
  const SubListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubListBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<SubListBloc>();
          return Scaffold(
            floatingActionButton: FloatingButton(
              onpressed: () async {
                log("starttttttttttttttttttttt");
                await bloc.initializeOneSignalAndRequestPermissions();

                final pushSubscription =
                    await OneSignal.User.pushSubscription.id!;

                if (OneSignal.User.pushSubscription.id != null &&
                    OneSignal.User.pushSubscription.optedIn == true) {
                  log(
                    "✅ الجهاز مشترك في الإشعارات: ${OneSignal.User.pushSubscription.id}",
                  );

                  // أرسل الإشعار
                  OneSignal.login(bloc.currentExternalId!);
                  await sendNotificationByExternalId(
                    externalUserId: [bloc.currentExternalId!],
                    title: "عنوان",
                    message: "محتوى الرسالة",
                  );
                } else {
                  log("❌ الجهاز غير مشترك في Push Notifications");
                }
                log("enddddddddddddddddddddddddddddddd");
              },
            ),
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    CupertinoIcons.person_crop_circle_fill_badge_plus,
                    color: StyleColor.green,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(" List Name", style: StyleText.bold24(context)),
                    Divider(thickness: .5),
                    StyleSize.sizeH48,
                    Image.asset("assets/images/2.png"),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "itemNoItems1".tr(),
                          style: StyleText.bold24(context),
                          children: <TextSpan>[
                            TextSpan(text: "\n"),

                            TextSpan(
                              text: "itemNoItems2".tr(),
                              style: StyleText.bold24(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StyleSize.sizeH8,
                    Center(
                      child: Text(
                        "itemAdd".tr(),
                        style: StyleText.regular16Green(
                          context,
                        ).copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
