/*
 * Task Model
 * Step: Represents a task item with id, title, and completion status.
 */
class Task {
  final String id;
  String title;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Step: Toggle method to switch completion status true <-> false
  void toggle() {
    isCompleted = !isCompleted;
  }
}