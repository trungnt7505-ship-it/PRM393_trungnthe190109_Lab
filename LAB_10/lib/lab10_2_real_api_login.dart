// ============================================================================
// LAB 10.2 – REAL REST API LOGIN
// ============================================================================
// Goal: Authenticate users using a real REST API (DummyJSON).
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Standalone main entry point for running Lab 10.2 independently
void main() {
  runApp(const Lab10_2_RealApiLoginApp());
}

// Lab 10.2 - Step 1: Create project/module Lab10_2_RealApiLogin
class Lab10_2_RealApiLoginApp extends StatelessWidget {
  const Lab10_2_RealApiLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.2 - Real API Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
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
  final _formKey = GlobalKey<FormState>();
  // DummyJSON sample valid credentials: emilys / emilyspass
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');

  // Lab 10.2 - Step 4: Handle loading and error states
  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  // Lab 10.2 - Step 2: Send POST login request to DummyJSON
  Future<void> _handleRealApiLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'expiresInMins': 60, // optional expiration time
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Lab 10.2 - Step 3: Parse token from response
        final data = jsonDecode(response.body);
        final String token = data['token'] ?? data['accessToken'] ?? '';
        final String firstName = data['firstName'] ?? '';
        final String lastName = data['lastName'] ?? '';
        final String email = data['email'] ?? '';
        final String image = data['image'] ?? '';

        if (!mounted) return;
        // Lab 10.2 - Step 5: Navigate to Home on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RealApiHomeScreen(
              username: username,
              fullName: '$firstName $lastName'.trim(),
              email: email,
              imageUrl: image,
              token: token,
            ),
          ),
        );
      } else {
        // Lab 10.2 - Step 4: Handle error state gracefully
        final errorData = jsonDecode(response.body);
        setState(() {
          _errorMessage = errorData['message'] ?? 'Login failed. Invalid username or password.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: $e';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.2 - Real API Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.api, size: 64, color: Colors.deepOrange),
                    const SizedBox(height: 16),
                    Text(
                      'DummyJSON REST API',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Endpoint: https://dummyjson.com/auth/login\n(Test user: emilys / emilyspass)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : _handleRealApiLogin,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login via REST API', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Lab 10.2 - Step 5: Home Screen after successful REST API Login
class RealApiHomeScreen extends StatelessWidget {
  final String username;
  final String fullName;
  final String email;
  final String imageUrl;
  final String token;

  const RealApiHomeScreen({
    super.key,
    required this.username,
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen (DummyJSON API)'),
        backgroundColor: Colors.deepOrange.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            if (imageUrl.isNotEmpty)
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(imageUrl),
              )
            else
              const CircleAvatar(
                radius: 48,
                child: Icon(Icons.person, size: 48),
              ),
            const SizedBox(height: 16),
            Text(
              fullName.isNotEmpty ? fullName : username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username: $username', style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    const Text('REST API Access Token:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    SelectableText(
                      token,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RealApiLoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
