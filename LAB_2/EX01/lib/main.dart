import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Declare variables using int, double, String, and bool
    int age = 21;
    double height = 1.75;
    String name = "Nguyen Thanh Trung";
    bool isStudent = true;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 1 - Basic Syntax & Data Types',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 1 – Basic Syntax & Data Types'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Variable Values:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Use text display and string interpolation ($var, ${expr}) to show values
              Text('Name: $name', style: const TextStyle(fontSize: 16)),
              Text('Age: $age', style: const TextStyle(fontSize: 16)),
              Text('Height: ${height}m', style: const TextStyle(fontSize: 16)), // Using ${expr} because of adjacent text 'm'
              Text('Is Student: $isStudent', style: const TextStyle(fontSize: 16)),
              Text('Next year age: ${age + 1}', style: const TextStyle(fontSize: 16)), // Using expression interpolation ${expr}
            ],
          ),
        ),
      ),
    );
  }
}