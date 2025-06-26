import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/buttom_widget.dart';

void completeItemBottomsheet({required BuildContext context}) {
  final bloc = context.read<SubListBloc>();

  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: StyleColor.white,
    showDragHandle: true,

    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(
              context,
            ).viewInsets.bottom,  
          ),
          child: SingleChildScrollView(
            child: Container(
              width: context.getWidth(),
              height: context.getHeight() * 0.7,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to start (left)
                children: [
                 StyleSize.sizeH32,
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text("item"),
                          subtitle: Text("create by"),
                        );
                      },
                    ),
                  ),
                  StyleSize.sizeH16,
                  ButtomWidget(onTab: () {  }, textElevatedButton: "receiptAdd".tr(),),
                   StyleSize.sizeH16,
                   ButtomWidget(onTab: () {  }, textElevatedButton: "checkoutwithoutreceipt".tr(),),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
