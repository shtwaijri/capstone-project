import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qaimati/features/members/service.dart';

class AddMemberPage extends StatefulWidget {
  final String listId;

  AddMemberPage({required this.listId});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("add members")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                print(email);
                if (email.isNotEmpty) {
                  print("starrt");
                  // Send invite
                  await sendInvite(email, widget.listId);

                  // Show SnackBar after sending the invite
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('invite has sent successfully')),
                  );
                }
              },
              child: Text("add members"),
            ),
          ],
        ),
      ),
    );
  }
}
