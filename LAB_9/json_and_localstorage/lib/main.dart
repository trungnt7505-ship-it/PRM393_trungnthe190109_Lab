import 'package:flutter/material.dart';
import 'screens/lab_9_1_screen.dart';
import 'screens/lab_9_2_screen.dart';
import 'screens/lab_9_3_screen.dart';

void main() {
  runApp(const Lab9App());
}

/// Main Application Entry Point for LAB 9 - Local JSON Storage
class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local JSON Storage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
      ),
      home: const Lab9MainNavigationScreen(),
    );
  }
}

/// Navigation screen combining Lab 9.1, Lab 9.2, and Lab 9.3 into a tabbed interface
class Lab9MainNavigationScreen extends StatefulWidget {
  const Lab9MainNavigationScreen({super.key});

  @override
  State<Lab9MainNavigationScreen> createState() =>
      _Lab9MainNavigationScreenState();
}

class _Lab9MainNavigationScreenState extends State<Lab9MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    Lab91Screen(),
    Lab92Screen(),
    Lab93Screen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.folder_open),
            selectedIcon: Icon(Icons.folder_open, color: Colors.teal),
            label: '9.1 Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.save_alt),
            selectedIcon: Icon(Icons.save_alt, color: Colors.teal),
            label: '9.2 Local Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage),
            selectedIcon: Icon(Icons.storage, color: Colors.teal),
            label: '9.3 JSON CRUD',
          ),
        ],
      ),
    );
  }
}
