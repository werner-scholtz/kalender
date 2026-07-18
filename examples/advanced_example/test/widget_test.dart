import 'package:advanced_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  testWidgets('renders the calendar with the per-person header', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(CalendarView), findsOneWidget);
    expect(find.byType(PeopleWidget), findsOneWidget);
  });
}
