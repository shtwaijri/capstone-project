import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';

class CustomListtile extends StatelessWidget {
  // Constructor for CustomListtile widget.
  const CustomListtile({
    super.key,
    required this.title, // The title text to display in the ListTile.
    this.onPressed, // Callback function for the trailing IconButton.
    required this.backgroundColor, // Background color for the Card.
  });

  final String title;
  final Function()? onPressed;
  final Color backgroundColor;
  final Color contentColor = StyleColor
      .black; // White color for content text, any chnages can be done on all content
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        // The Card widget provides a Material Design card with rounded corners and elevation.
        // It wraps the ListTile to give it the desired rounded appearance and shadow.
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // Sets horizontal and vertical margins around the card for spacing.
        shape: RoundedRectangleBorder(
          // Defines the shape of the card's border.
          borderRadius: BorderRadius.circular(15.0),
          // Applies a circular border radius of 15.0 to all corners, making them rounded.
        ),
        elevation: 3.0,
        // Adds a shadow (elevation) to the card, making it appear lifted.
        color: backgroundColor,
        // Sets the background color of the card using the provided 'backgroundColor'.
        child: ListTile(
          // The core list item widget.
          leading: Icon(
            // Icon displayed at the beginning of the list tile.
            Icons.list,
            color: contentColor,
            // Sets the color of the leading icon to white for visibility against the background.
          ),
          title: Text(
            // The main text content of the list tile.
            title,
            style: TextStyle(
              color: contentColor,
            ).copyWith(fontWeight: FontWeight.bold),
            // Sets the color of the title text to white.
          ),
          trailing: Icon(
            // The icon inside the IconButton.
            Icons.arrow_forward_ios, // A right-pointing arrow icon.
            color: contentColor,

            // Sets the color of the trailing icon to white.
          ),
        ),
      ),
    );
  }
}
