import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('the calendar renders without the bridge', (tester) async {
    await tester.pumpWidget(_app(bridge: false));
    expect(tester.takeException(), isNull);
    expect(find.byType(CalendarBody), findsOneWidget);
  });

  testWidgets('with the bridge the calendar renders', (tester) async {
    await tester.pumpWidget(_app(bridge: true));
    expect(tester.takeException(), isNull);
    expect(find.byType(CalendarBody), findsOneWidget);
  });
}

Widget _app({required bool bridge}) {
  return MaterialApp(
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    builder: bridge
        // ignore: deprecated_member_use
        ? (context, child) => MaterialUiCompatibilityBridge(child: child!)
        : null,
    home: Scaffold(body: _Calendar()),
  );
}

class _Calendar extends StatefulWidget {
  @override
  State<_Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  @override
  void dispose() {
    eventsController.dispose();
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: KalenderDateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now.add(const Duration(days: 7)),
        ),
      ),
      body: const CalendarBody(),
    );
  }
}
