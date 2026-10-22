/*
 * =====================================================================
 * LAB 11.3 – Navigation Testing: Task List -> Task Detail
 * Step 1: Create task_navigation_test.dart file in test/widget/.
 * Step 2: Seed repository with at least one task.
 * Step 3: Pump TaskListScreen.
 * Step 4: Tap seeded task and call pumpAndSettle().
 * Step 5: Validate AppBar title ("Task Detail") and TextField key.
 * =====================================================================
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';
import '../../lib/models/task.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  testWidgets('Tapping seeded task navigates to TaskDetailScreen', (WidgetTester tester) async {
    // Step 2: Seed repository
    final repository = TaskRepository();
    final seededTask = Task(id: '101', title: 'Seeded Navigation Task');
    repository.addTask(seededTask);

    // Step 3: Pump TaskListScreen
    await tester.pumpWidget(TasklyApp(repository: repository));

    // Step 4: Tap seeded task & call pumpAndSettle()
    await tester.tap(find.text('Seeded Navigation Task'));
    await tester.pumpAndSettle();

    // Step 5: Validate navigation results
    expect(find.text('Task Detail'), findsOneWidget);
    expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
  });
}