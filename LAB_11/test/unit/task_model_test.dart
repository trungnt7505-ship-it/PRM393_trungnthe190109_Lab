/*
 * LAB 11.1 / 11.5 – Unit Testing: Task Model
 */
import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/task.dart';

void main() {
  group('Task Model Unit Tests', () {
    test('Task should have default isCompleted as false', () {
      final task = Task(id: '1', title: 'Buy Milk');
      expect(task.isCompleted, isFalse);
    });

    test('toggle() should switch completion status correctly', () {
      final task = Task(id: '1', title: 'Study Flutter');
      task.toggle();
      expect(task.isCompleted, isTrue);
      task.toggle();
      expect(task.isCompleted, isFalse);
    });
  });
}