import 'package:flutter/material.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';
import 'app_structure_theme_demo.dart';
import 'common_ui_fixes_demo.dart';

void main() {
  runApp(const Lab4App());
}

class Lab4App extends StatelessWidget {
  const Lab4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter UI Fundamentals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Lab4HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Lab4HomeScreen extends StatelessWidget {
  const Lab4HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 – Flutter UI Fundamentals'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            'Exercise 1 – Core Widgets Demo',
            const CoreWidgetsDemo(),
          ),
          _buildMenuCard(
            context,
            'Exercise 2 – Input Controls Demo',
            const InputControlsDemo(),
          ),
          _buildMenuCard(
            context,
            'Exercise 3 – Layout Demo',
            const LayoutDemo(),
          ),
          _buildMenuCard(
            context,
            'Exercise 4 – App Structure & Theme',
            const AppStructureThemeDemo(),
          ),
          _buildMenuCard(
            context,
            'Exercise 5 – Common UI Fixes',
            const CommonUiFixesDemo(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, Widget destination) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
      ),
    );
  }
}