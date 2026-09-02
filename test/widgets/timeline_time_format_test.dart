import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The timeline labels its hours with `MaterialLocalizations` where the app
/// installs them, and with intl where it does not.
///
/// The second path is what an app on the standalone `material_ui` package hits,
/// which used to throw `No MaterialLocalizations found`. See issue #491.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUpAll(initializeDateFormatting);

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  tearDown(() {
    calendarController.dispose();
    eventsController.dispose();
  });

  final tiles = TileComponents(tileBuilder: (context, event, range) => const SizedBox());

  /// A calendar with no Material ancestor at all, so no `MaterialLocalizations`.
  /// The overlay is what the drag targets need and `MaterialApp` would provide.
  Widget withoutMaterial(Locale locale, Widget child) => WidgetsApp(
        color: const Color(0xFF000000),
        locale: locale,
        builder: (context, _) => Overlay(
          initialEntries: [OverlayEntry(builder: (context) => child)],
        ),
      );

  Widget calendar(Locale locale) => KalenderView(
        eventsController: eventsController,
        calendarController: calendarController,
        locale: locale,
        viewConfiguration: MultiDayViewConfiguration.week(displayRange: year2025DisplayRange),
        body: CalendarBody(multiDayTileComponents: tiles),
      );

  String labelAt(WidgetTester tester, int hour) {
    return tester.widget<Text>(find.byKey(TimeLine.getTimeKey(hour, 0)).first).data!;
  }

  testWidgets('an app without MaterialLocalizations renders rather than throwing', (tester) async {
    await tester.pumpWidget(withoutMaterial(const Locale('de'), calendar(const Locale('de'))));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(labelAt(tester, 9), '09:00', reason: 'intl formatted it for the calendar\'s locale');
  });

  testWidgets('the calendar locale decides the intl format', (tester) async {
    await tester.pumpWidget(withoutMaterial(const Locale('en'), calendar(const Locale('en'))));
    await tester.pumpAndSettle();

    // intl writes a narrow no-break space before the marker where Material uses
    // a plain one, so compare on the parts rather than the separator.
    expect(labelAt(tester, 9), startsWith('9:00'));
    expect(labelAt(tester, 9), endsWith('AM'));
  });

  // MaterialLocalizations wins wherever they are installed, so an app that works
  // today keeps the labels it has. DefaultMaterialLocalizations covers en only,
  // so a German calendar inside a MaterialApp still labels in English, which is
  // exactly what it did before this change.
  testWidgets('MaterialLocalizations still decide the format when present', (tester) async {
    await pumpAndSettleWithMaterialApp(tester, calendar(const Locale('de')));

    expect(labelAt(tester, 9), '9:00 AM');
  });
}
