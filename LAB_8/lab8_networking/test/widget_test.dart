import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab8_networking/main.dart';

void main() {
  testWidgets('MyApp loads PostListScreen title correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the AppBar title displays 'API Powered List Screen'.
    expect(find.text('API Powered List Screen'), findsOneWidget);
  });
}
