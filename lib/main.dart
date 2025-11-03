import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger_app/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Messenger',
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        scaffoldBackgroundColor: const Color(0xFFECE5DD),
      ),
      home: LoginPage(),
    );
  }
}
