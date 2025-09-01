// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:scio_flutter/main.dart';

void main() {
  testWidgets('Navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScioApp());

    // Verify that the home screen is displayed
    expect(find.text('Home Screen - À implémenter'), findsOneWidget);
    
    // Verify that the navigation items are present
    expect(find.text('Scanner'), findsOneWidget);
    expect(find.text('Historique'), findsOneWidget);
    expect(find.text('Favoris'), findsOneWidget);
    expect(find.text('Recherche'), findsOneWidget);
    
    // Test navigation to Scanner screen
    await tester.tap(find.text('Scanner'));
    await tester.pumpAndSettle();
    expect(find.text('Scanner Screen - À implémenter'), findsOneWidget);
    
    // Test navigation to History screen
    await tester.tap(find.text('Historique'));
    await tester.pumpAndSettle();
    expect(find.text('Historique Screen - À implémenter'), findsOneWidget);
  });
}
