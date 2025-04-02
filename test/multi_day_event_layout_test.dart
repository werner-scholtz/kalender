import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_event_layout_widget.dart';

import 'utilities.dart';

void main() {
  testWidgets('MultiDayEventLayoutWidget (MonthView)', (tester) async {
    final controller = CalendarController<int>();
    final interaction = ValueNotifier(CalendarInteraction());
    final tileComponents = TileComponents<int>(
      tileBuilder: (event, tileRange) => Container(
        key: ValueKey(event.data!),
        child: Text(event.data.toString()),
      ),
    );

    final start = DateTime(2025, 3, 24);
    final end = DateTime(2025, 3, 31);
    final visibleRange = DateTimeRange(start: start.asUtc, end: end.asUtc);

    final events = [
      CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)), data: 1),
      CalendarEvent<int>(dateTimeRange: DateTimeRange(start: start, end: start.copyWith(day: start.day + 3)), data: 2),
      CalendarEvent<int>(
        dateTimeRange: DateTimeRange(start: start, end: start.add(const Duration(hours: 6))),
        data: 3,
      ),
    ];

    final eventsController = DefaultEventsController<int>()..addEvents(events);

    const tileHeight = 50.0;
    const dayWidth = 50.0;
    const maxNumberOfVerticalEvents = 2;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        MultiDayEventLayoutWidget<int>(
          events: eventsController.events.toList(),
          eventsController: eventsController,
          controller: controller,
          visibleDateTimeRange: visibleRange,
          tileComponents: tileComponents,
          callbacks: null,
          dayWidth: dayWidth,
          showAllEvents: true,
          tileHeight: tileHeight,
          maxNumberOfVerticalEvents: maxNumberOfVerticalEvents,
          interaction: interaction,
          generateMultiDayLayoutFrame: defaultMultiDayFrameGenerator<int>,
          eventPadding: const EdgeInsets.all(0),
          textDirection: TextDirection.rtl,
          multiDayOverlayBuilders: null,
          multiDayOverlayStyles: null,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the events are laid out correctly
    expect(find.byKey(const ValueKey(1)), findsOneWidget);
    expect(find.byKey(const ValueKey(2)), findsOneWidget);
    // This should be hidden as it exceeds the max number of vertical events.
    expect(find.byKey(const ValueKey(3)), findsNothing);

    final numberOfButtons = tester.widgetList(find.byType(MultiDayPortalOverlayButton)).length;
    // Verify that the number of buttons is correct
    expect(numberOfButtons, 1);
  });
}
