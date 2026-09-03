import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

void main() {
  // Regression for #233: selecting a month-view event that sits on the second
  // row must project the focus/drop-target onto that same row, not the first.
  testWidgets('#233 selected event focus lands on the event row', (tester) async {
    final eventsController = DefaultEventsController();
    final calendarController = KalenderController();

    // Two events covering the same days (Tue–Thu of the first full week) so they
    // stack: one on row 0, one on row 1.
    final range = KalenderDateTimeRange(start: DateTime(2025, 1, 7), end: DateTime(2025, 1, 10));
    final eventA = KalenderEvent(start: range.start, end: range.end);
    final eventB = KalenderEvent(start: range.start, end: range.end);
    eventsController.addEvent(eventA);
    eventsController.addEvent(eventB);

    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => SizedBox.expand(key: ValueKey('tile-${event.id}')),
      dropTargetTile: (context, event) => SizedBox.expand(key: ValueKey('drop-${event.id}')),
    );

    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MonthViewConfiguration.singleMonth(
          displayRange: KalenderDateTimeRange(start: DateTime(2024, 12), end: DateTime(2025, 3)),
          initialDateTime: DateTime(2025, 1),
        ),
        body: KalenderBody(monthTileComponents: tiles),
      ),
    );

    final topA = tester.getRect(find.byKey(ValueKey('tile-${eventA.id}'))).top;
    final topB = tester.getRect(find.byKey(ValueKey('tile-${eventB.id}'))).top;
    expect(topA, isNot(moreOrLessEquals(topB, epsilon: 1.0)), reason: 'The two events should stack on separate rows');

    // Selecting either event must project the focus onto that event's own row —
    // the bug in #233 was that it always landed on the first row.
    Future<double> dropTopFor(KalenderEvent event) async {
      calendarController.selectEvent(event);
      await tester.pumpAndSettle();
      return tester.getRect(find.byKey(ValueKey('drop-${event.id}'))).top;
    }

    expect(await dropTopFor(eventA), moreOrLessEquals(topA, epsilon: 1.0), reason: 'Focus must align with event A row');
    expect(await dropTopFor(eventB), moreOrLessEquals(topB, epsilon: 1.0), reason: 'Focus must align with event B row');
  });
}
