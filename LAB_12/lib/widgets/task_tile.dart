import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onToggle;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(task.id),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: onToggle,
      ),
      onTap: onTap,
    );
  }
}