import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/day_tile.dart';

import '../utilities.dart';

/// [ResizeHandleStyle] sizes the area [DefaultResizeHandles] gives each handle.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController calendarController;
  late String eventId;

  KalenderInteraction interactionFor(InputMode mode) => KalenderInteraction(
        allowResizing: true,
        allowRescheduling: true,
        inputMode: mode,
      );

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
    eventId = eventsController.addEvent(
      KalenderEvent(start: DateTime(2025, 1, 1, 1), end: DateTime(2025, 1, 1, 4)),
    );
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  Future<void> pumpDay(WidgetTester tester, {ResizeHandleStyle? style, InputMode mode = InputMode.precise}) {
    final view = KalenderView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.singleDay(
        displayRange: year2025DisplayRange,
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        initialHeightPerMinute: 1,
        initialDateTime: DateTime(2025, 1, 1),
      ),
      body: KalenderBody(
        interaction: interactionFor(mode),
        multiDayTileComponents: TileComponents(
          tileBuilder: (context, event, tileRange) => const SizedBox.expand(),
          verticalResizeHandle: const SizedBox.expand(),
        ),
      ),
    );

    return pumpAndSettleWithMaterialApp(
      tester,
      style == null ? view : KalenderTheme(data: KalenderThemeData(resizeHandleStyle: style), child: view),
    );
  }

  /// The height of the handle for [eventId] facing [direction].
  double handleHeight(WidgetTester tester, ResizeDirection direction) {
    return tester
        .getSize(
          find.byWidgetPredicate(
            (widget) => widget is ResizeDetector && widget.event.id == eventId && widget.direction == direction,
          ),
        )
        .height;
  }

  testWidgets('a precise handle is 16 long by default', (tester) async {
    await pumpDay(tester);
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(handleHeight(tester, ResizeDirection.top), 16);
    expect(handleHeight(tester, ResizeDirection.bottom), 16);
  });

  testWidgets('the theme changes the precise handle length', (tester) async {
    await pumpDay(tester, style: const ResizeHandleStyle(length: 30));
    await tester.hoverOn(find.byKey(DayEventTile.tileKey(eventId)), await tester.createMouseGesture());

    expect(handleHeight(tester, ResizeDirection.top), 30);
    expect(handleHeight(tester, ResizeDirection.bottom), 30);
  });

  /// Imprecise input shows the handles on selection rather than on hover.
  Future<void> select(WidgetTester tester) async {
    calendarController.selectEvent(eventsController.events.firstWhere((event) => event.id == eventId));
    await tester.pumpAndSettle();
  }

  testWidgets('an imprecise handle is 24 long by default', (tester) async {
    await pumpDay(tester, mode: InputMode.imprecise);
    await select(tester);

    expect(handleHeight(tester, ResizeDirection.top), 24);
  });

  testWidgets('the theme changes the imprecise handle length', (tester) async {
    await pumpDay(tester, style: const ResizeHandleStyle(length: 30, impreciseLength: 44), mode: InputMode.imprecise);
    await select(tester);

    expect(handleHeight(tester, ResizeDirection.top), 44, reason: 'imprecise input takes the imprecise length');
  });
}
