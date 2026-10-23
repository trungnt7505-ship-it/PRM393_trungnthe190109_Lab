import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

/*
 * =====================================================================
 * PRM393 — LAB 12: Performance Optimization
 * - Exercise 12.1: Optimize list rebuilds (TaskTile + ValueKey)
 * - Exercise 12.2: Optimize image memory usage (Image.asset + cacheWidth)
 * - Exercise 12.3: Optimize large list scrolling (ListView cacheExtent & const)
 * =====================================================================
 */
class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _inputController = TextEditingController();

  void _addNewTask() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        widget.repository.addTask(
          Task(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: text,
          ),
        );
        _inputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly - Lab 12 Full Optimization'),
      ),
      body: Column(
        children: [
          // =========================================================
          // EXERCISE 12.2: Banner image optimized for RAM memory (cacheWidth)
          // =========================================================
          Container(
            height: 140,
            width: double.infinity,
            margin: const EdgeInsets.all(8.0),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/images/banner.png',
              fit: BoxFit.cover,
              cacheWidth: 800, // Optimize decoded image size in RAM to prevent over-allocation
            ),
          ),

          // Task input section (Using const constructors for static widgets)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _inputController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                ),
                IconButton(
                  key: const Key('addTaskButton'),
                  icon: const Icon(Icons.add),
                  onPressed: _addNewTask,
                ),
              ],
            ),
          ),

          // Task list container
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
            // =========================================================
            // EXERCISE 12.3: Optimize ListView using cacheExtent
            // Manages the off-screen cache area to prevent frame jank
            // during fast scrolling of large lists.
            // =========================================================
                : ListView.builder(
              cacheExtent: 250.0, // Define custom cache render area
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                // EXERCISE 12.1: TaskTile + ValueKey to prevent full list repaints
                return TaskTile(
                  task: task,
                  onToggle: (_) {
                    setState(() {
                      task.toggle();
                    });
                  },
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          task: task,
                          repository: widget.repository,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                );
              },
            )
          ),
        ],
      ),
    );
  }
}