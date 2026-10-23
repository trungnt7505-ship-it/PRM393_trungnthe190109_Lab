import 'package:flutter/material.dart';
import 'repositories/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() {
  runApp(TasklyApp(repository: TaskRepository()));
}

class TasklyApp extends StatelessWidget {
  final TaskRepository repository;

  const TasklyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly Lab 12',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: repository),
    );
  }
}