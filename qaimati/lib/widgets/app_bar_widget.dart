import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';

/// A customizable AppBar widget that displays:
/// - A title
/// - Optional action icon
/// - Optional search bar

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({
    super.key,
    required this.title,
    required this.showActions,
    this.actionsIcon,
    required this.showSearchBar,
    required this.showBackButton,
  });

  /// Title text to display in the AppBar
  final String title;

  /// Whether to show the action icon on the right

  final bool showActions;

  /// The list widget to display if [showActions] is true
  final List<Widget>? actionsIcon;

  /// Whether to display the search bar under the title
  final bool showSearchBar;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : Container(),

      // Show the action icon if enabled
      actions: showActions ? actionsIcon : null,

      // Add custom content under the AppBar (title + optional search bar)
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(showSearchBar ? 150 : 110),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              // Title text
              Text(title, style: StyleText.bold24(context)),

              // Show search bar only if enabled
              if (showSearchBar)
                SearchBar(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0.0),
                  backgroundColor: WidgetStateProperty.all(
                    StyleColor.graylight,
                  ),
                  hintText: 'commonSearch'.tr(),
                  hintStyle: WidgetStateProperty.all(
                    StyleText.regular16Grey(context),
                  ),
                  leading: Icon(CupertinoIcons.search, color: StyleColor.gray),
                ),

              // Bottom divider line
              Container(color: StyleColor.graylight, height: 1),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(showSearchBar ? 150 : 110);
}
