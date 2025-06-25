import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qaimati/widgets/custom_listtile.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("Login screen"),
          CustomListtile(
            title: "List Name",
            backgroundColor: Color(0xffFF8699),
            onPressed: () {
              log("message");
            },
          ),
        ],
      ),
    );
  }
}
