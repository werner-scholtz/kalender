import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// A custom [ResizeHandlePositioner] returns a plain [Widget] and receives a
/// [ResizeHandleDetails], which carries the tile's geometry and resolves the
/// handle widgets from the context.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;
  late String eventId;

  final interaction = CalendarInteraction(
    allowResizing: true,
    allowRescheduling: true,
    inputMode: InputMode.precise,
  );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
    eventId = eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4)),
      ),
    );
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Future<void> pumpDay(WidgetTester tester, TileComponents tiles) {
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderTheme(
        data: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF00FF00))),
        child: CalendarView(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: MultiDayViewConfiguration.singleDay(
            displayRange: year2025DisplayRange,
            initialTimeOfDay: const TimeOfDay(hour: 0, minute: 0),
            initialDateTime: DateTime(2025, 1, 1),
          ),
          body: CalendarBody(interaction: interaction, multiDayTileComponents: tiles),
        ),
      ),
    );
  }

  testWidgets('a custom positioner receives a context it can resolve the theme from', (tester) async {
    Color? resolved;

    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
      resizeHandlePositioner: (context, details) {
        resolved = KalenderTheme.of(context).daySeparatorStyle?.color;
        return Stack(
          fit: StackFit.expand,
          key: _probeKey,
          children: [
            Positioned(top: 0, left: 0, right: 0, height: 8, child: details.startResizeDetector),
            Positioned(bottom: 0, left: 0, right: 0, height: 8, child: details.endResizeDetector),
          ],
        );
      },
    );

    await pumpDay(tester, tiles);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(find.byKey(_probeKey), findsWidgets);
    expect(resolved, const Color(0xFF00FF00));
  });

  testWidgets('the details resolve the handle widgets from the context', (tester) async {
    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
      verticalResizeHandle: const _Handle(),
      resizeHandlePositioner: (context, details) => details.resizeHandle(context),
    );

    await pumpDay(tester, tiles);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(find.byType(_Handle), findsWidgets);
  });
}

/// Identifies the widget a custom positioner returned.
const _probeKey = ValueKey<String>('probe-resize-handles');

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
