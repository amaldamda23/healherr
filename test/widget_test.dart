import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healher/main.dart';

void main() {
  testWidgets('HealHer app loads successfully', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const HealHerApp());

    // Wait for any async operations (auth check, animations)
    await tester.pump();

    // Verify the app loaded without crashing
    expect(find.byType(HealHerApp), findsOneWidget);

    // Verify loading screen is shown initially
    expect(find.text('HealHer'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify the flower emoji is displayed
    expect(find.text('🌸'), findsOneWidget);
  });
}
