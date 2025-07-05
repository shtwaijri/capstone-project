 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';


/// A widget that allows users to select and adjust the quantity of an item.
///
/// This selector displays the current quantity in a bordered text  
/// and provides two `IconButton`s for incrementing and decrementing the quantity.
/// It interacts with the `SubListBloc` by dispatching `IncrementNumberEvent`
/// and `DecrementNumberEvent` to update the item quantity in the BLoC's state.
/// The UI rebuilds only when the `SubListLoadedState` is emitted, ensuring
/// the displayed quantity is always in sync with the BLoC.

class ItemQuantitySelector extends StatelessWidget {
  const ItemQuantitySelector({super.key, });
 
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SubListBloc>(); 
    return BlocBuilder<SubListBloc, SubListState>(
      buildWhen: (previous, current) => current is SubListLoadedState,  
      builder: (context, state) {
       
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
                  "${bloc.number}",  
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