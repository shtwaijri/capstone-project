// screens/create_list_screen.dart
import 'package:flutter/material.dart';
import 'package:qaimati/features/members/list_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/list_service.dart'; // استيراد الملف الذي يحتوي على الميثودات

class CreateListScreen extends StatefulWidget {
  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'List Name'),
            ),
            TextField(
              controller: colorController,
              decoration: InputDecoration(labelText: 'Color (Number)'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                int color = int.tryParse(colorController.text) ?? 0;

                // التأكد من وجود الـ session وuserId
                final session = Supabase.instance.client.auth.currentSession;
                if (session == null || session.user?.id == null) {
                  print('Error: User not authenticated.');
                  return;
                }
                String userId =
                    session.user!.id; // استخدام الـ userId من الـ session

                // استدعاء الميثود لإنشاء اللستة مع تمرير userId
                createList(name, color, userId); // هنا ننادي الميثود من الملف
              },
              child: Text('Create List'),
            ),
          ],
        ),
      ),
    );
  }
}
