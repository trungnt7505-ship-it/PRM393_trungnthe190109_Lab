/*
 * =====================================================================
 * Lab 10.4 – Firebase Authentication (Google Sign-In Simulation)
 * Goal: Integrate Google Sign-In UI and user profile management.
 * =====================================================================
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab10_4App());
}

class Lab10_4App extends StatelessWidget {
  const Lab10_4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 Google Sign-In',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const GoogleSignInScreen(),
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;

  // Step 3: Implement Google Sign-In flow (Simulated for instant running)
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulating popup Google dialog

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(
          name: 'Nguyen Thanh Trung',
          email: 'trungnt@fpt.edu.vn',
          photoUrl: 'https://avatars.githubusercontent.com/u/10000000?v=4',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.4 – Google Sign-In')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
          onPressed: _signInWithGoogle,
          icon: const Icon(Icons.g_mobiledata, size: 30),
          label: const Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  // Step 5: Logout and return to Sign-In screen
  void _signOut(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GoogleSignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Step 4: Display user profile information
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(photoUrl),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, size: 45),
            ),
            const SizedBox(height: 16),
            Text('Name: $name', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: $email', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _signOut(context),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}