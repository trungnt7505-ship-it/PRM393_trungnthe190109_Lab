import 'package:flutter_test/flutter_test.dart';
import 'package:lab8b_rest_api/main.dart';

void main() {
  testWidgets('WeatherCompanionApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherCompanionApp());

    // Verify that the Weather Companion app title is displayed.
    expect(find.text('Weather Companion'), findsOneWidget);
  });
}
