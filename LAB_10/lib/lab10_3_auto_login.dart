// ============================================================================
// LAB 10.3 – AUTO LOGIN & LOGOUT (SESSION MANAGEMENT)
// ============================================================================
// Goal: Persist authentication state and restore login automatically using SharedPreferences.
// ============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Standalone main entry point for running Lab 10.3 independently
void main() {
  runApp(const Lab10_3_AutoLoginApp());
}

// Lab 10.3 - Step 1: Create project/module Lab10_3_AutoLogin_Logout
class Lab10_3_AutoLoginApp extends StatelessWidget {
  const Lab10_3_AutoLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.3 - Auto Login & Logout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Lab 10.3 - Step 3: Implement SplashScreen routing
      home: const AutoLoginSplashScreen(),
    );
  }
}

// Lab 10.3 - Step 3: SplashScreen routing to check token persistence
class AutoLoginSplashScreen extends StatefulWidget {
  const AutoLoginSplashScreen({super.key});

  @override
  State<AutoLoginSplashScreen> createState() => _AutoLoginSplashScreenState();
}

class _AutoLoginSplashScreenState extends State<AutoLoginSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  // Lab 10.3 - Step 4: Auto-login if token exists
  Future<void> _checkSavedSession() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate initial splash check

    final prefs = await SharedPreferences.getInstance();
    final String? savedToken = prefs.getString('auth_token');
    final String? savedUsername = prefs.getString('auth_username');

    if (!mounted) return;

    if (savedToken != null && savedToken.isNotEmpty) {
      // Auto-login: token found, skip login screen and navigate directly to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AutoHomeScreen(
            username: savedUsername ?? 'Saved User',
            token: savedToken,
          ),
        ),
      );
    } else {
      // No persistent token found: navigate to Login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AutoLoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 80),
            SizedBox(height: 24),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Checking Authentication Session...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({super.key});

  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

class _AutoLoginScreenState extends State<AutoLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(text: 'emilys');
  final TextEditingController _passwordController = TextEditingController(text: 'emilyspass');

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _loginAndSaveSession() async {
    if (!_formKey.currentState!.validate()) return;

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
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'] ?? data['accessToken'] ?? '';

        // Lab 10.3 - Step 2: Save token after login using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('auth_username', username);

        if (!mounted) return;

        // Navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AutoHomeScreen(
              username: username,
              token: token,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Connection error: $e';
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
        title: const Text('Lab 10.3 - Auto Login'),
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
                    const Icon(Icons.screen_lock_portrait, size: 64, color: Colors.teal),
                    const SizedBox(height: 16),
                    Text(
                      'Session Persistence',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tokens are saved to SharedPreferences for auto-login on app launch.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage != null) ...[
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v!.isEmpty ? 'Enter password' : null,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _isLoading ? null : _loginAndSaveSession,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Login & Save Session'),
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

class AutoHomeScreen extends StatelessWidget {
  final String username;
  final String token;

  const AutoHomeScreen({
    super.key,
    required this.username,
    required this.token,
  });

  // Lab 10.3 - Step 5: Logout clears session and returns to Login
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    // Clear session tokens from local storage
    await prefs.remove('auth_token');
    await prefs.remove('auth_username');

    if (!context.mounted) return;

    // Force re-authentication and clear widget stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AutoLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home (Auto Logged In)'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.verified_user, size: 80, color: Colors.teal),
            const SizedBox(height: 16),
            Text(
              'Welcome Back, $username!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your login session is persisted in SharedPreferences.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SelectableText('Stored Token: $token'),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Logout & Clear Session'),
            ),
          ],
        ),
      ),
    );
  }
}
