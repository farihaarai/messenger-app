import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:messenger_app/models/user.dart';
import 'package:messenger_app/screens/chat_screen.dart';
import 'package:messenger_app/screens/login_page.dart';
import 'package:uuid/uuid.dart';

class ChatListScreen extends StatefulWidget {
  final firebase_auth.User currentUser;
  const ChatListScreen({super.key, required this.currentUser});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Future<List<QueryDocumentSnapshot>> fetchUsersFromServer() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get(const GetOptions(source: Source.server));
    return querySnapshot.docs;
  }

  Future<void> _addUserDialog() async {
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New User"),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Enter user email",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) return;

                await _addUserToFirestore(email);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addUserToFirestore(String email) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final existing = await usersRef.where('email', isEqualTo: email).get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User already exists")));
      return;
    }

    final newUserId = const Uuid().v4();
    await usersRef.doc(newUserId).set({
      'id': newUserId,
      'name': email.split('@')[0], // temporary name from email prefix
      'email': email,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("User added successfully")));

    setState(() {}); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text("Chats"),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await firebase_auth.FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              }
            },
            icon: const Icon(Icons.login_outlined),
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchUsersFromServer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data ?? [];
          final userList = docs
              .where((doc) => doc['id'] != widget.currentUser.uid)
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
                subtitle: const Text("Tap to chat"),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addUserDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
