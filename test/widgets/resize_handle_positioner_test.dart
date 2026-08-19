import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// A custom [ResizeHandlePositioner] receives a [BuildContext] and no longer
/// receives the [TileComponents]. The base class resolves the handle widgets
/// from the context, so a subclass builds the detectors without carrying them.
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
      resizeHandlePositioner: (context, event, interaction, dateTimeRange, size, axis, isImprecise) {
        resolved = KalenderTheme.of(context).daySeparatorStyle?.color;
        return _ProbeResizeHandles(
          event: event,
          interaction: interaction,
          dateTimeRange: dateTimeRange,
          size: size,
          axis: axis,
          isImprecise: isImprecise,
        );
      },
    );

    await pumpDay(tester, tiles);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(find.byType(_ProbeResizeHandles), findsWidgets);
    expect(resolved, const Color(0xFF00FF00));
  });

  testWidgets('the base class resolves the handle widgets from the context', (tester) async {
    final tiles = TileComponents(
      tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
      verticalResizeHandle: const _Handle(),
      resizeHandlePositioner: (context, event, interaction, dateTimeRange, size, axis, isImprecise) {
        return _HandleOnly(
          event: event,
          interaction: interaction,
          dateTimeRange: dateTimeRange,
          size: size,
          axis: axis,
          isImprecise: isImprecise,
        );
      },
    );

    await pumpDay(tester, tiles);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(find.byType(_Handle), findsWidgets);
  });
}

/// Builds the package's own resize detectors, which no longer need the
/// [TileComponents] passed to them.
class _ProbeResizeHandles extends ResizeHandles {
  const _ProbeResizeHandles({
    required super.event,
    required super.interaction,
    required super.dateTimeRange,
    required super.size,
    required super.axis,
    required super.isImprecise,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(top: 0, left: 0, right: 0, height: 8, child: startResizeDetector),
        Positioned(bottom: 0, left: 0, right: 0, height: 8, child: endResizeDetector),
      ],
    );
  }
}

/// Uses [ResizeHandles.resizeHandle], which resolves the handle widget from the
/// context rather than from a field.
class _HandleOnly extends ResizeHandles {
  const _HandleOnly({
    required super.event,
    required super.interaction,
    required super.dateTimeRange,
    required super.size,
    required super.axis,
    required super.isImprecise,
  });

  @override
  Widget build(BuildContext context) => resizeHandle(context, axis);
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
