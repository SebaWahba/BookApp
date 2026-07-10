import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookapp/app.dart';

void main() {
  testWidgets('App builds and shows Splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BookApp());

    expect(find.text('Bazar.'), findsOneWidget);
  });
}