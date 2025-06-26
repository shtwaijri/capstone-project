


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/sub_list/bloc/sub_list_bloc.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';

void completeItemBottomsheet({
  required BuildContext context,
  
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
               Expanded(
                 child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context,index){
                  return    ListTile(
                      title: Text("item"),
                      subtitle: Text("createby"),
                    );
                  }),
               ),
               SizedBox(height: 16,),
               SizedBox(
                width: double.infinity, // Make the button take full width
                child: ElevatedButton(
                  onPressed: () {
                    // Add your logic for "Add the item" button
                    // You can access bloc.isItemImportant here to know the importance
                    
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
                   "Add receipt",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
                SizedBox(height: 12,),
               SizedBox(
                width: double.infinity, // Make the button take full width
                child: ElevatedButton(
                  onPressed: () {
                    // Add your logic for "Add the item" button
                    // You can access bloc.isItemImportant here to know the importance
                 
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
                  "checkout without receipt",
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