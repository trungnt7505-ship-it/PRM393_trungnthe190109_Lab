/*
 * LAB 11.4 / 11.5 – Integration Testing: Full E2E Flow
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  testWidgets('Full E2E Flow: Add task -> Open detail -> Edit -> Save -> Verify list update', (WidgetTester tester) async {
    final repository = TaskRepository();
    await tester.pumpWidget(TasklyApp(repository: repository));

    // Add task
    await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();
    expect(find.text('Original title'), findsOneWidget);

    // Open detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();
    expect(find.text('Task Detail'), findsOneWidget);

    // Edit title
    final detailField = find.byKey(const Key('detailTitleField'));
    await tester.enterText(detailField, 'Updated title');

    // Save
    await tester.tap(find.byKey(const Key('saveDetailButton')));
    await tester.pumpAndSettle();

    // Verify
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}