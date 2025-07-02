import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/expenses/screens/expenses_screen.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/completed_screen.dart';
import 'package:qaimati/models/item/item_model.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_size.dart';
import 'package:qaimati/style/style_text.dart';
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
            bottom: MediaQuery.of(context).viewInsets.bottom,
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
                  Center(
                    child: Text(
                      "checkeditems".tr(),
                      style: StyleText.bold24(context),
                    ),
                  ),
                  StyleSize.sizeH24,
                  BlocBuilder<SubListBloc, SubListState>(
                    builder: (context, state) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: bloc.checkedItems.length,
                          itemBuilder: (context, index) {
                            final item = bloc.checkedItems[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "${item.quantity} - ${item.title}",
                                    style: StyleText.bold16(context),
                                  ),

                                  subtitle: Text(
                                    "${"memberCreatedBy".tr()} ${item.createdBy!}",
                                  ),
                                ),
                                SizedBox(height: 4),
                                Divider(
                                  height: 0,
                                  color: StyleColor.gray,
                                  thickness: 1.01,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  StyleSize.sizeH16,
                  ButtomWidget(
                    onTab: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExpensesScreen(),
                        ),
                      );
                    },
                    textElevatedButton: "receiptAdd".tr(),
                  ),
                  StyleSize.sizeH16,
                  ButtomWidget(
                    onTab: () {
                      bloc.add(GetCompletedItemsEvent());
                      bloc.add(LoadItemsEvent());
                      // bloc.add(ResetBlocStateEvent());
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: bloc,
                            // child: CompletedScreen(),
                          ),
                        ),
                      );
                    },
                    textElevatedButton: "movecompleted".tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
