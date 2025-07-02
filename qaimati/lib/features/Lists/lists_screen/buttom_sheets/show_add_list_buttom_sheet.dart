import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/widgets/select_color.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/text_field_widget.dart';
// import 'package:test_befor_add/screens/lists/bloc/add_list_bloc.dart';
// import 'package:test_befor_add/screens/select_color.dart';
// import 'package:test_befor_add/style/style_color.dart';
// import 'package:test_befor_add/style/style_text.dart';
// import 'package:test_befor_add/utilities/extensions/screens/get_size_screen.dart';
// // import 'package:test_befor_add/widgets/buttom_widget.dart';
// import 'package:test_befor_add/widgets/text_field_widget.dart';

void showAddListButtomSheet({required BuildContext context}) {
  TextEditingController addListController = TextEditingController();
  // final bloc = context.read<AddListBloc>();

  showModalBottomSheet(
    showDragHandle: true,
    backgroundColor: StyleColor.white,
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocProvider(
        create: (context) => AddListBloc(),
        child: Builder(
          builder: (context) {
            final bloc = context.read<AddListBloc>();
            return FractionallySizedBox(
              // give buttom sheet persen size of screen
              heightFactor: 0.5, // 0.5 = 50% of screen height
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Add new list', style: StyleText.bold16(context)),
                          TextFieldWidget(
                            controller: addListController,
                            textHint: 'List name',
                          ),
            
                          BlocBuilder<AddListBloc, AddListState>(
                            builder: (context, state) {
                              return SelectColor(
                                selected: bloc.selectColor,
                                onTapSelect: bloc.changeColor,
                              );
                            },
                          ),
                        ],
                      ),
                      // ButtomWidget(
                      //   onTab: () {},
                      //   textElevatedButton: 'textElevatedButton',
                      // ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: StyleColor.green,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          fixedSize: Size(
                            context.getWidth() * .9,
                            context.getHeight() * 0.06,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Create list',
                          style: StyleText.buttonText(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      );
    },
  );
}
