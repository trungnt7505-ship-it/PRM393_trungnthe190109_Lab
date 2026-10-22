/*
 * LAB 11.1 / 11.5 – Unit Testing: Task Repository
 */
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/task.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() should add a new task to repository', () {
      final task = Task(id: '1', title: 'Test Task');
      repository.addTask(task);
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Test Task');
    });

    test('deleteTask() should remove task by ID', () {
      final task = Task(id: '1', title: 'Task to Delete');
      repository.addTask(task);
      repository.deleteTask('1');
      expect(repository.tasks.isEmpty, isTrue);
    });

    test('updateTask() should modify title of existing task', () {
      final task = Task(id: '1', title: 'Old Title');
      repository.addTask(task);
      repository.updateTask('1', 'Updated Title');
      expect(repository.tasks.first.title, 'Updated Title');
    });
  });
}