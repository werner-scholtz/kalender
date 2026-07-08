import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart' show MultiDayEventTile;

import '../utilities.dart';

// Coverage for #252: MonthBodyConfiguration should expose eventPadding, forward
// it to the shared HorizontalConfiguration, and carry it through copyWith, so
// month event tiles can be spaced like the multi-day header already allows.
void main() {
  group('MonthBodyConfiguration eventPadding (#252)', () {
    test('constructor exposes eventPadding', () {
      const padding = EdgeInsets.fromLTRB(1, 2, 3, 4);
      expect(const MonthBodyConfiguration(eventPadding: padding).eventPadding, padding);
    });

    test('defaults to kDefaultMultiDayEventPadding', () {
      expect(const MonthBodyConfiguration().eventPadding, kDefaultMultiDayEventPadding);
    });

    test('copyWith updates eventPadding', () {
      const updated = EdgeInsets.all(9);
      final config = const MonthBodyConfiguration(eventPadding: EdgeInsets.all(1)).copyWith(eventPadding: updated);
      expect(config.eventPadding, updated);
    });

    test('copyWith preserves eventPadding when it is not passed', () {
      const padding = EdgeInsets.all(4);
      final config = const MonthBodyConfiguration(eventPadding: padding).copyWith(tileHeight: 30);
      expect(config.eventPadding, padding);
    });

    testWidgets('applies the configured eventPadding to month event tiles', (tester) async {
      const padding = EdgeInsets.fromLTRB(11, 12, 13, 14);
      final eventsController = DefaultEventsController();
      final calendarController = CalendarController();

      eventsController.addEvent(
        CalendarEvent(
          dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 15, 9), end: DateTime(2025, 1, 15, 10)),
        ),
      );

      await pumpAndSettleWithMaterialApp(
        tester,
        CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MonthViewConfiguration.singleMonth(
            displayRange: DateTimeRange(start: DateTime(2024, 12), end: DateTime(2025, 3)),
            initialDateTime: DateTime(2025, 1),
          ),
          body: const CalendarBody(
            monthBodyConfiguration: MonthBodyConfiguration(eventPadding: padding),
          ),
        ),
      );

      expect(find.byType(MultiDayEventTile), findsWidgets, reason: 'The event should render a tile');
      expect(
        find.ancestor(
          of: find.byType(MultiDayEventTile),
          matching: find.byWidgetPredicate((widget) => widget is Padding && widget.padding == padding),
        ),
        findsWidgets,
        reason: 'Each month event tile should be wrapped in the configured eventPadding',
      );
    });
  });
}
