import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class ItemQuantitySelector extends StatelessWidget {
  const ItemQuantitySelector({super.key, this.number = 0});
  final int number;

  @override
  Widget build(BuildContext context) {
      final bloc = context.read<SubListBloc>();

    return BlocBuilder<SubListBloc, SubListState>(
      builder: (context, state) {
        int currentNumber = number;
        if (state is ChangeNumberState) {
          currentNumber = state.number;
        }

        return Row(
          mainAxisSize: MainAxisSize.min, // This is crucial to make the Row take minimum space
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              width: context.getWidth()*.1,
              height:context.getHeight()*.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.grey, width: 2),
              ),
              child: Center(
                child: Text(
                  "$currentNumber",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // No SizedBox here to ensure no horizontal space between Container and Column
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    bloc.add(DecrementNumberEvent());
                  },
                  icon: const Icon(
                    CupertinoIcons.minus_square_fill,
                    color: Color(0xffB4DE95),
                  ),
                  color: Colors.white,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    bloc.add(IncrementNumberEvent());
                  },
                  icon: const Icon(
                    CupertinoIcons.plus_app_fill,
                    color: Color(0xffB4DE95),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}