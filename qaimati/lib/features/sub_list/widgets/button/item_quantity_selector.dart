 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

class ItemQuantitySelector extends StatelessWidget {
  const ItemQuantitySelector({super.key, this.number = 1});
  final int number; 

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SubListBloc>(); 

    return BlocBuilder<SubListBloc, SubListState>(
      buildWhen: (previous, current) => current is SubListLoadedState,  
      builder: (context, state) {
        int displayQuantity = 1;
        if (state is SubListLoadedState) {
          displayQuantity = state.currentNumber;  
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              width: context.getWidth()*.13,
              height:context.getHeight()*.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular( 4.0,),
                border: Border.all(color: StyleColor.gray, width: 2),
              ),
              child: Center(
                child: Text(
                  "${displayQuantity}", // 🔴 اعرض القيمة من state
                  style:StyleText.bold16(context),
                ),
              ),
            ),
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
                    color: StyleColor.green,
                  ),
                  color: StyleColor.white,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    bloc.add(IncrementNumberEvent());
                  },
                  icon: const Icon(
                    CupertinoIcons.plus_app_fill,
                    color: StyleColor.green,
                  ),
                  color:StyleColor.white,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}