/*
 * LAB 11.2 / 11.5 – Widget Testing: Task List UI
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  group('Task List Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('Displays "No tasks yet. Add one!" when list is empty', (WidgetTester tester) async {
      await tester.pumpWidget(TasklyApp(repository: repository));
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Entering text and tapping add button adds task to list UI', (WidgetTester tester) async {
      await tester.pumpWidget(TasklyApp(repository: repository));
      await tester.enterText(find.byKey(const Key('taskInputField')), 'New Task 1');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('New Task 1'), findsOneWidget);
    });

    testWidgets('Adding two tasks displays both in the list UI', (WidgetTester tester) async {
      await tester.pumpWidget(TasklyApp(repository: repository));

      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task 1');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      await tester.enterText(find.byKey(const Key('taskInputField')), 'Task 2');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });
  });
}