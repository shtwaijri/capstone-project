import 'package:flutter/material.dart';
import 'package:qaimati/widgets/empty_widget.dart';
// import 'package:test_befor_add/widgets/empty_widget.dart';

class TestEmptyWedgit extends StatelessWidget {
  const TestEmptyWedgit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: EmptyWidget(
          lable: 'test',
          // notEptyList: false,
          img: '',
          isOnboarding: false,
          hint: 'hint',
        ),  
      ),
    );
  }
}