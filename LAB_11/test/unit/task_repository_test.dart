/*
 * LAB 11.1 – Unit Testing: Task Repository
 * Step 1: Create task_repository_test.dart file in test/unit/.
 * Step 2: Test addTask() method.
 * Step 3: Test deleteTask() method.
 * Step 4: Test updateTask() method.
 * Step 5: Apply AAA pattern (Arrange -> Act -> Assert).
 */
import 'package:flutter_test/flutter_test.dart';
import '../../lib/repositories/task_repository.dart';
import '../../lib/models/task.dart';

void main() {
  group('TaskRepository Unit Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    test('addTask() should add a new task to repository', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task');
      // Act
      repository.addTask(task);
      // Assert
      expect(repository.tasks.length, 1);
      expect(repository.tasks.first.title, 'Test Task');
    });

    test('deleteTask() should remove task by ID', () {
      // Arrange
      final task = Task(id: '1', title: 'Task to Delete');
      repository.addTask(task);
      // Act
      repository.deleteTask('1');
      // Assert
      expect(repository.tasks.isEmpty, isTrue);
    });

    test('updateTask() should modify title of existing task', () {
      // Arrange
      final task = Task(id: '1', title: 'Old Title');
      repository.addTask(task);
      // Act
      repository.updateTask('1', 'Updated Title');
      // Assert
      expect(repository.tasks.first.title, 'Updated Title');
    });
  });
}