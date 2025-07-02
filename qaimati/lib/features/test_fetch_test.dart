import 'package:flutter/material.dart';
import 'package:qaimati/utilities/helper/userId_helper.dart';

class TestUserIdScreen extends StatelessWidget {
  const TestUserIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? userId;

    try {
      userId = fetchUserIdFromSupabase();
    } catch (e) {
      userId = 'Error: $e';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Test User ID')),
      body: Center(
        child: Text(
          userId ?? 'No user ID found',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
