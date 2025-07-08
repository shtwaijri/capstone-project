import 'package:flutter/material.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';

class PrimeContent extends StatelessWidget {
  const PrimeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "data",
        showActions: false,
        showSearchBar: false,
        showBackButton: true,
      ),
    );
  }
}
