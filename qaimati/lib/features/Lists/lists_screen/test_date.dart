import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/Lists/lists_screen/bloc/add_list_bloc.dart';
import 'package:qaimati/features/Lists/widgets/lists_buttons.dart';
import 'package:qaimati/features/expenses/screens/expenses_screen.dart';
import 'package:qaimati/features/sub_list/completed_screen/completed_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/widgets/custom_listtile.dart';
// import 'package:qaimati/bloc/add_list_bloc.dart';
import 'package:qaimati/widgets/empty_widget.dart';

class TestDataLayerScreen extends StatelessWidget {
  const TestDataLayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddListBloc()..add(LoadListsEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Test Data Layer (BLoC)')),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListsButtons(
                      // cusomt widget
                      icon: Icon(Icons.check_box, color: StyleColor.green),
                      quantity: '0',
                      lable: 'completed',
                      screen:
                          CompletedScreen(), // tis screen to go to some page
                    ),
                    ListsButtons(
                      icon: Icon(
                        Icons.people_alt_rounded,
                        color: StyleColor.blue,
                      ),
                      quantity: '0',
                      lable: 'External list',
                      screen: ExpensesScreen(),
                    ),
                  ],
                ),

                SizedBox(height: 16.0),
                Divider(color: StyleColor.gray, thickness: 2.0),

                BlocBuilder<AddListBloc, AddListState>(
              builder: (context, state) {
                if (state is AddListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AddListError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is AddListLoaded) {
                  final lists = state.lists;

                  // if (lists.isEmpty) {
                  //   return EmptyWidget(lable: 'No lists here', img: '');
                  // }

                  return lists.isEmpty
                      ? EmptyWidget(lable: 'no list here', img: '', hint: 'add list',)
                      : Expanded(
                        child: ListView.builder(
                            itemCount: lists.length,
                            itemBuilder: (context, index) {
                              final list = lists[index];
                              return CustomListtile(title: list.name, backgroundColor: list.getColor(),);
                            },
                          ),
                      );
                } else {
                  return const Center(child: Text('No state'));
                }
              },
            ),
              ],
            ),
          );
        },
      ),
    );
  }
}
