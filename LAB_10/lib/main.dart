/*
 * =====================================================================
 * Lab 10.1 – Mock Login (Backend Simulation)
 * Goal: Build a login screen with validation and simulate backend authentication.
 * Description: Create a login UI and simulate a backend authentication 
 *              process using a mock service with a delayed response and token.
 * =====================================================================
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const Lab10_1App());
}

class Lab10_1App extends StatelessWidget {
  const Lab10_1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.1 Mock Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MockLoginScreen(),
    );
  }
}

class MockLoginScreen extends StatefulWidget {
  const MockLoginScreen({super.key});

  @override
  State<MockLoginScreen> createState() => _MockLoginScreenState();
}

class _MockLoginScreenState extends State<MockLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Task: Simulate authentication with a delay and mock token
  void _mockLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate network delay (1.5 seconds)
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() => _isLoading = false);

      // Check mock credentials (Expected: admin@fpt.edu.vn / 123456)
      if (_emailController.text == 'admin@fpt.edu.vn' &&
          _passwordController.text == '123456') {
        // Navigate to Home screen on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(token: 'mock_token_123456'),
          ),
        );
      } else {
        // Display error message for invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials! Try admin@fpt.edu.vn / 123456'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.1 – Mock Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field with validation
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 12),
              // Password input field with validation
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _mockLogin,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Successful!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Token: $token', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MockLoginScreen()),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}