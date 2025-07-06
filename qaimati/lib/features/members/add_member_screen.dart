// import 'package:flutter/material.dart';
// import 'package:qaimati/features/members/notification_service.dart';

// class AddMemberPage extends StatelessWidget {
//   final String listId;
//   final TextEditingController emailController = TextEditingController();

//   AddMemberPage({required this.listId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("إضافة عضو")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "البريد الإلكتروني"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final email = emailController.text.trim();
//                 if (email.isNotEmpty) {
//                   // استدعاء دالة إرسال الدعوة
//                   await NotificationService().sendInvite(
//                     'user-id-here', // استبدل بـ userId الفعلي
//                     email,
//                     listId,
//                   );
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text('تم إرسال الدعوة!')));
//                 }
//               },
//               child: Text("إضافة العضو"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
