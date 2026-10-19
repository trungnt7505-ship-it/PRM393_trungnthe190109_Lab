/*
 * =====================================================================
 * Lab 10.2 – Real REST API Login
 * Goal: Authenticate users using a real REST API (DummyJSON).
 * Description: This lab replaces mock authentication with a real HTTP login request.
 *              Students practice handling API responses, loading states, and errors.
 * =====================================================================
 */

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Lab10_2App());
}

class Lab10_2App extends StatelessWidget {
  const Lab10_2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.2 Real API Login',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RealApiLoginScreen(),
    );
  }
}

class RealApiLoginScreen extends StatefulWidget {
  const RealApiLoginScreen({super.key});

  @override
  State<RealApiLoginScreen> createState() => _RealApiLoginScreenState();
}

class _RealApiLoginScreenState extends State<RealApiLoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspassword');

  // Step 4: Handle loading and error states
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _loginWithApi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Step 2: Send POST login request to DummyJSON
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': 'emilys',       // Thử đổi username khác nếu cần
          'password': 'emilyspassword', // Kiểm tra lại mật khẩu test của tài khoản này
        }),
      );

      final data = jsonDecode(response.body);

      // Step 3: Parse token from response
      if (response.statusCode == 200 && data['token'] != null) {
        String token = data['token'];
        String firstName = data['firstName'] ?? 'User';

        if (!mounted) return;
        // Step 5: Navigate to Home on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeApiScreen(username: firstName, token: token),
          ),
        );
      } else {
        // Expected Output: Errors are handled gracefully
        setState(() {
          _errorMessage = data['message'] ?? 'Login failed. Invalid credentials.';
        });
      }
    } catch (e) {
      // Step 4: Handle loading and error states
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.2 – Real REST API Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            // Display error state
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 24),
            // Display loading state
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _loginWithApi,
              child: const Text('Login via API'),
            ),
          ],
        ),
      ),
    );
  }
}

// Expected Output: Login succeeds using real API
class HomeApiScreen extends StatelessWidget {
  final String username;
  final String token;
  const HomeApiScreen({super.key, required this.username, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome, $username')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $username!', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Token: ${token.substring(0, 20)}...', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RealApiLoginScreen()),
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