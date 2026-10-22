/*
 * LAB 11.3 / 11.5 – Navigation Testing: Task List -> Task Detail
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';
import '../../lib/models/task.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  testWidgets('Tapping seeded task navigates to TaskDetailScreen', (WidgetTester tester) async {
    final repository = TaskRepository();
    final seededTask = Task(id: '101', title: 'Seeded Navigation Task');
    repository.addTask(seededTask);

    await tester.pumpWidget(TasklyApp(repository: repository));

    await tester.tap(find.text('Seeded Navigation Task'));
    await tester.pumpAndSettle();

    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}