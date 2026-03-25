import 'package:flutter_test/flutter_test.dart';
import 'package:recurrence/main.dart';

void main() {
  testWidgets('App renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify the calendar toolbar is present.
    expect(find.text('Kalender Recurrence Example'), findsNothing); // title is in MaterialApp, not visible
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
