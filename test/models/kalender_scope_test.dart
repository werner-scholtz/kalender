import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// [KalenderScope] reads the state of the calendar a widget is built inside.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = KalenderController();
  });

  tearDown(() {
    eventsController.dispose();
    calendarController.dispose();
  });

  /// Pumps a calendar whose day header runs [read] and renders what it returns.
  Future<void> pumpReading(WidgetTester tester, String Function(BuildContext context) read) {
    final tiles = TileComponents(tileBuilder: (context, event, range) => const SizedBox());
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        locale: const Locale('de'),
        viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: year2025DisplayRange),
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderStringBuilder: (context, date) => read(context),
            ),
          ),
        ),
        header: KalenderHeader(multiDayTileComponents: tiles),
        body: KalenderBody(multiDayTileComponents: tiles),
      ),
    );
  }

  testWidgets('reads the controllers the calendar was given', (tester) async {
    await pumpReading(tester, (context) {
      final events = KalenderScope.eventsControllerOf(context);
      final calendar = KalenderScope.calendarControllerOf(context);
      return '${identical(events, eventsController)}/${identical(calendar, calendarController)}';
    });
    expect(find.text('true/true'), findsWidgets);
  });

  testWidgets('reads the locale the calendar was given', (tester) async {
    await pumpReading(tester, (context) => '${KalenderScope.localeOf(context)}');
    expect(find.text('de'), findsWidgets);
  });

  testWidgets('reads the nearest interaction rather than the calendar-wide one', (tester) async {
    final tiles = TileComponents(tileBuilder: (context, event, range) => const SizedBox());
    await pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(displayRange: year2025DisplayRange),
        components: KalenderComponents(
          multiDayComponents: MultiDayComponents(
            headerComponents: MultiDayHeaderComponents(
              dayHeaderStringBuilder: (context, date) => '${KalenderScope.interactionOf(context).allowResizing}',
            ),
          ),
        ),
        header: KalenderHeader(
          multiDayTileComponents: tiles,
          interaction: KalenderInteraction(allowResizing: false),
        ),
        body: KalenderBody(
          multiDayTileComponents: tiles,
          interaction: KalenderInteraction(allowResizing: true),
        ),
      ),
    );

    // true is the default, so false is the only value that proves which one was read.
    expect(
      find.text('false'),
      findsWidgets,
      reason: 'the day header reads the header interaction, not the body or the default',
    );
  });

  testWidgets('the maybe form returns null outside a calendar', (tester) async {
    await pumpAndSettleWithMaterialApp(
      tester,
      Builder(
        builder: (context) => Text(
          '${KalenderScope.maybeEventsControllerOf(context)}/${KalenderScope.maybeCalendarControllerOf(context)}',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
    expect(find.text('null/null'), findsOneWidget);
  });
}
