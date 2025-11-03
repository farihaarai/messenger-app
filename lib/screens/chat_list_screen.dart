import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:messenger_app/models/user.dart';
import 'package:messenger_app/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final firebase_auth.User currentUser;
  const ChatListScreen({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text("Chats"),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data!.docs;
          // Exclude the logged-in user
          final userList = docs
              .where((doc) => doc['id'] != currentUser.uid)
              .toList();
          if (userList.isEmpty) {
            return const Center(child: Text("No users found."));
          }
          return ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal.shade400,
                  child: Text(
                    (user['name'] ?? '')[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(user['name'] ?? user['email']),
                subtitle: Text("Tap to chat"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        user: User(
                          id: user['id'],
                          name: user['name'],
                          email: user['email'],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:messenger_app/data/dummy_data.dart';
// import 'package:messenger_app/models/user.dart';
// import 'package:messenger_app/screens/chat_screen.dart';

// class ChatListScreen extends StatelessWidget {
//   const ChatListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final List<User> users = [];

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.teal,
//         elevation: 4,
//         leading: const Icon(Icons.chat_rounded, color: Colors.white),
//         title: const Text(
//           'Messenger',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             letterSpacing: 0.5,
//           ),
//         ),
//         // centerTitle: true,
//         // actions: [
//         //   IconButton(
//         //     icon: const Icon(Icons.search, color: Colors.white),
//         //     onPressed: () {
//         //       // Search feature coming soon!
//         //     },
//         //   ),
//         //   IconButton(
//         //     icon: const Icon(Icons.more_vert, color: Colors.white),
//         //     onPressed: () {
//         //       // Menu or settings
//         //     },
//         //   ),
//         // ],
//       ),

//       body: ListView.builder(
//         itemCount: dummyUsers.length,
//         itemBuilder: (context, index) {
//           User user = dummyUsers[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.teal.shade400,
//               child: Text(user.name[0], style: TextStyle(color: Colors.white)),
//             ),
//             title: Text(user.name),
//             subtitle: Text('Tap to chat'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
