import 'package:flutter/material.dart';
import 'screens/post_list_screen.dart';
import 'services/api_service.dart';

// Lab 8 - Building an API-powered List Screen (Flutter + REST API)
// Step 1: Project Setup & Entry Point

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate ApiService layer instance
    final apiService = ApiService();

    return MaterialApp(
      title: 'Lab 8 - Networking & API List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      // Home screen points to PostListScreen with ApiService injected
      home: PostListScreen(apiService: apiService),
    );
  }
}
