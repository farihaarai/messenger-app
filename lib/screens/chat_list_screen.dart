import 'package:flutter/material.dart';
import 'package:messenger_app/data/dummy_data.dart';
import 'package:messenger_app/models/user.dart';
import 'package:messenger_app/screens/chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<User> users = [otherUser];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 4,
        leading: const Icon(Icons.chat_rounded, color: Colors.white),
        title: const Text(
          'Messenger',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        // centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Colors.white),
        //     onPressed: () {
        //       // Search feature coming soon!
        //     },
        //   ),
        //   IconButton(
        //     icon: const Icon(Icons.more_vert, color: Colors.white),
        //     onPressed: () {
        //       // Menu or settings
        //     },
        //   ),
        // ],
      ),

      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal.shade400,
              child: Text(user.name[0], style: TextStyle(color: Colors.white)),
            ),
            title: Text(user.name),
            subtitle: Text('Tap to chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(user: user)),
              );
            },
          );
        },
      ),
    );
  }
}
