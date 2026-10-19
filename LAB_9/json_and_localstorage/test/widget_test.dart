import 'package:flutter_test/flutter_test.dart';
import 'package:json_and_localstorage/main.dart';

void main() {
  testWidgets('Lab 9 app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Lab9App());

    // Verify that Lab 9.1 title appears on screen
    expect(find.text('Lab 9.1 - Read JSON From Assets'), findsOneWidget);
  });
}
