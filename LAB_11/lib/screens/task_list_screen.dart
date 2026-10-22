import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import 'task_detail_screen.dart';

/*
 * Task List Screen
 * Displays task list, supports adding tasks, toggling status,
 * and navigating to TaskDetailScreen upon item tap.
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
      appBar: AppBar(title: const Text('Taskly')),
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
                    decoration: const InputDecoration(hintText: 'Enter task name'),
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
            // Empty state requirement
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                // ListTile implementation with onTap navigation & checkbox toggle
                return ListTile(
                  key: Key('taskTile_${task.id}'),
                  title: Text(task.title),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      setState(() {
                        task.toggle();
                      });
                    },
                  ),
                  onTap: () async {
                    // Step: Navigate to TaskDetailScreen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(
                          task: task,
                          repository: widget.repository,
                        ),
                      ),
                    );
                    setState(() {}); // Refresh list upon returning
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