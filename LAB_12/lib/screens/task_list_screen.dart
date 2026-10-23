import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

/*
 * =====================================================================
 * EXERCISE 12.2 — Image & Asset Optimization in Taskly
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
        title: const Text('Taskly - Lab 12.2'),
      ),
      body: Column(
        children: [

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
              cacheWidth: 800,


            ),
          ),

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
          Expanded(
            child: tasks.isEmpty
                ? const Center(
              child: Text('No tasks yet. Add one!'),
            )
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
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