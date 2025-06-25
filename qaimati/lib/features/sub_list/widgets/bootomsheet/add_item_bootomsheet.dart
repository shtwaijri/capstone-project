import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/features/sub_list/widgets/button/item_quantity_selector.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

void showAddItemBottomShaeet({
  required BuildContext context,
  required int number,
}) {
  final bloc = context.read<SubListBloc>();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: Container(
          width: context.getWidth(),
          height: context.getHeight() * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to start (left)
            children: [
                SizedBox(height: 32),
              Text(
                "Item", // Add the "Item" text as seen in the image
                style: TextStyle(
                  fontSize: context.getHeight()*.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: ItemQuantitySelector(number: number),
                  ),
                  Flexible(
                    flex: 5,
                    child: TextField(
                      controller: bloc.itemController,
                      decoration: InputDecoration(
                        hintText: "Enter item Name ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners for text field
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Add a SizedBox here if you need space between the row and the icon
              // SizedBox(height: 16), // Adjust this value as needed for vertical spacing

              BlocBuilder<SubListBloc, SubListState>(
                // Listen only to ChooseImportanceState to rebuild just the icon
                buildWhen: (previous, current) => current is ChooseImportanceState,
                builder: (context, state) {
                  bool isExclamationImportant = false; // Default
                  if (state is ChooseImportanceState) {
                    isExclamationImportant = state.isImportant;
                  } else if (bloc.isItemImportant != null) {
                    // Initial state or if not a ChooseImportanceState, get from bloc's stored value
                    isExclamationImportant = bloc.isItemImportant;
                  }

                  return Align( // Use Align to position the icon
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Toggle the importance state and dispatch the event
                        context.read<SubListBloc>().add(
                              ChooseImportanceEvent(isImportant: !isExclamationImportant),
                            );
                      },
                      icon: Icon(
                      isExclamationImportant  ?CupertinoIcons.exclamationmark_square:CupertinoIcons.exclamationmark_square_fill,
                        // Change color based on the state from the BLoC
                        color:  Colors.red , // Or any default color when not important
                        size: 24, // Adjust size as needed
                      ),
                    ),
                  );
                },
              ),

              Spacer(), // Pushes the button to the bottom
              SizedBox(
                width: double.infinity, // Make the button take full width
                child: ElevatedButton(
                  onPressed: () {
                    // Add your logic for "Add the item" button
                    // You can access bloc.isItemImportant here to know the importance
                    print('Item Name: ${bloc.itemController.text}');
                    print('Quantity: ${bloc.number}');
                    print('Is Important: ${bloc.isItemImportant}');
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffB4DE95), // Green color from image
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners for button
                    ),
                  ),
                  child: const Text(
                   "Add the item",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}