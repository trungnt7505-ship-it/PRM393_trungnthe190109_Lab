import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

/*
 * =====================================================================
 * EXERCISE 12.1 — Optimize List Rebuilds in Taskly
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
        title: const Text('Taskly - Lab 12.1'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                // Sử dụng TaskTile đã được tách và gán ValueKey để tối ưu
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
            ),
          ),
        ],
      ),
    );
  }
}