import 'package:flutter/material.dart' as legacy;
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('without the bridge the timeline cannot resolve MaterialLocalizations', (tester) async {
    await tester.pumpWidget(_app(bridge: false));
    expect(tester.takeException(), isA<FlutterError>());
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

class _Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return KalenderView(
      eventsController: DefaultEventsController(),
      calendarController: CalendarController(),
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: legacy.DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now.add(const Duration(days: 7)),
        ),
      ),
      body: const CalendarBody(),
    );
  }
}
