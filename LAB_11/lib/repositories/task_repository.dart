import '../models/task.dart';

/*
 * Task Repository
 * Step: Manages the list of tasks in-memory.
 */
class TaskRepository {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  // Step: Add task to the repository
  void addTask(Task task) {
    _tasks.add(task);
  }

  // Step: Delete task from the repository
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
  }

  // Step: Update task title or status
  void updateTask(String id, String newTitle) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].title = newTitle;
    }
  }
}