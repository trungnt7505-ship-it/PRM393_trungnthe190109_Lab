/*
 * LAB 11.1 – Unit Testing: Task Model
 * Step 1: Create test/unit/ folder and task_model_test.dart file.
 * Step 2: Test default completed value (isCompleted must be false).
 * Step 3: Test toggle() method switches completion status (false <-> true).
 * Step 4: Apply AAA pattern (Arrange -> Act -> Assert).
 */
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Task should have default isCompleted as false', () {
      // Arrange
      final task = Task(id: '1', title: 'Buy Milk');
      // Act & Assert
      expect(task.isCompleted, isFalse);
    });

    test('toggle() should switch completion status correctly', () {
      // Arrange
      final task = Task(id: '1', title: 'Study Flutter');
      // Act & Assert
      task.toggle();
      expect(task.isCompleted, isTrue);
      task.toggle();
      expect(task.isCompleted, isFalse);
    });
  });
}