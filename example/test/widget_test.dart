import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home screen offers every example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Open HORIZONTAL example'), findsOneWidget);
    expect(find.text('Open VERTICAL example'), findsOneWidget);
    expect(find.text('Open BOUNCING HORIZONTAL example'), findsOneWidget);
    expect(find.text('Open BOUNCING VERTICAL example'), findsOneWidget);
    expect(find.text('Open PAUSE AT END example'), findsOneWidget);
    expect(find.text('Open OVERFLOW example'), findsOneWidget);
  });

  testWidgets('opens the overflow example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Open OVERFLOW example'));
    await tester.pumpAndSettle();

    expect(find.text('Overflow Example'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
