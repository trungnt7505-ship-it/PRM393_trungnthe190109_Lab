/*
 * =====================================================================
 * LAB 11.4 – Integration Testing: Full E2E Flow
 * Step 1: Create task_integration_test.dart file in test/widget/ folder[cite: 3].
 * Step 2: Simulate full flow: Add "Original title"[cite: 3].
 * Step 3: Tap task -> open detail[cite: 3].
 * Step 4: Edit title -> "Updated title" and save[cite: 3].
 * Step 5: Verify updated title appears in list[cite: 3].
 * =====================================================================
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart';
import '../../lib/repositories/task_repository.dart';

void main() {
  testWidgets('Full E2E Flow: Add task -> Open detail -> Edit -> Save -> Verify list update', (WidgetTester tester) async {
    final repository = TaskRepository();
    await tester.pumpWidget(TasklyApp(repository: repository));

    // Step 2: Add "Original title"
    await tester.enterText(find.byKey(const Key('taskInputField')), 'Original title');
    await tester.tap(find.byKey(const Key('addTaskButton')));
    await tester.pump();
    expect(find.text('Original title'), findsOneWidget);

    // Step 3: Tap task -> open detail
    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();
    expect(find.text('Task Detail'), findsOneWidget);

    // Step 4: Edit -> "Updated title"
    final detailField = find.byKey(const Key('detailTitleField'));
    await tester.enterText(detailField, 'Updated title');

    // Step 4 (cont.): Save
    await tester.tap(find.byKey(const Key('saveDetailButton')));
    await tester.pumpAndSettle();

    // Step 5: Verify updated title appears in list
    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text('Original title'), findsNothing);
  });
}