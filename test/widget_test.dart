// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures, and use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gorm_wiki/main.dart';

void main() {
  testWidgets('App starts and shows MaterialApp', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    // Verify that MaterialApp is created
    expect(find.byType(MaterialApp), findsOneWidget);

    // Pump the timer to complete the navigation in PoweredBy
    await tester.pump(const Duration(seconds: 4));
  });
}
