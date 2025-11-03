import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/screens/chat_list_screen.dart';
import 'package:messenger_app/screens/signin_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> loginUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatListScreen(currentUser: userCredential.user!),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _error = 'No user found for this email. Please sign up.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() => _error = 'Incorrect password.');
      } else {
        setState(() => _error = e.message);
      }
    } catch (e) {
      setState(() => _error = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF075E54);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.message_outlined, color: green, size: 90),
                SizedBox(height: 30),
                Text(
                  'Login to Messenger',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: green,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                if (!_loading)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Login'),
                    ),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    // Navigate to your sign up page (or replace with your sign up logic)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignInPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Color(0xFF075E54)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
