import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  testWidgets('renders the calendar and toolbar', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(CalendarView), findsOneWidget);
    expect(find.byIcon(Icons.today), findsOneWidget);
  });
}
