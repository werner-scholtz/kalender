import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// The multi-day body builders take a [BuildContext] and resolve their own
/// styles from it, all of them from the nearest [KalenderTheme].
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  Future<void> pumpWeek(
    WidgetTester tester, {
    CalendarComponents? components,
    KalenderThemeData? theme,
  }) async {
    final view = CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: DateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)),
      ),
      components: components,
      header: CalendarHeader(multiDayTileComponents: tiles),
      body: CalendarBody(multiDayTileComponents: tiles),
    );
    await pumpAndSettleWithMaterialApp(
      tester,
      theme == null ? view : KalenderTheme(data: theme, child: view),
    );
  }

  CalendarComponents bodyComponents(MultiDayBodyComponents components) {
    return CalendarComponents(multiDayComponents: MultiDayComponents(bodyComponents: components));
  }

  testWidgets('a custom timeline resolves the timeline style from its context', (tester) async {
    await pumpWeek(
      tester,
      theme: const KalenderThemeData(timelineStyle: TimelineStyle(width: 123)),
      components: bodyComponents(
        MultiDayBodyComponents(
          timeline: (context, heightPerMinute, timeOfDayRange, eventBeingDragged, visibleDateTimeRange) {
            return Text('${KalenderTheme.of(context).timelineStyle?.width}', key: const ValueKey('timeline'));
          },
        ),
      ),
    );

    expect(find.byKey(const ValueKey('timeline')), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const ValueKey('timeline'))).data, '123.0');
  });

  testWidgets('a custom hour lines builder resolves its style from the theme', (tester) async {
    await pumpWeek(
      tester,
      theme: const KalenderThemeData(hourLinesStyle: HourLinesStyle(color: Color(0xFF00FF00))),
      components: bodyComponents(
        MultiDayBodyComponents(
          hourLines: (context, heightPerMinute, timeOfDayRange) {
            final color = KalenderTheme.of(context).hourLinesStyle?.color;
            return ColoredBox(color: color!, key: const ValueKey('hourLines'));
          },
        ),
      ),
    );

    final box = tester.widget<ColoredBox>(find.byKey(const ValueKey('hourLines')));
    expect(box.color, const Color(0xFF00FF00));
  });

  testWidgets('a custom day separator resolves its style from the theme', (tester) async {
    await pumpWeek(
      tester,
      theme: const KalenderThemeData(daySeparatorStyle: DaySeparatorStyle(color: Color(0xFF0000FF))),
      components: bodyComponents(
        MultiDayBodyComponents(
          daySeparator: (context) => _Probe(KalenderTheme.of(context).daySeparatorStyle?.color),
        ),
      ),
    );

    final probes = tester.widgetList<_Probe>(find.byType(_Probe));
    expect(probes, isNotEmpty);
    expect(probes.every((probe) => probe.color == const Color(0xFF0000FF)), isTrue);
  });

  testWidgets('a custom time indicator resolves its style from the theme', (tester) async {
    await pumpWeek(
      tester,
      theme: const KalenderThemeData(timeIndicatorStyle: TimeIndicatorStyle(lineColor: Color(0xFFFF0000))),
      components: bodyComponents(
        MultiDayBodyComponents(
          timeIndicator: (context, timeOfDayRange, heightPerMinute, location) {
            return _Probe(KalenderTheme.of(context).timeIndicatorStyle?.lineColor);
          },
        ),
      ),
    );

    final probes = tester.widgetList<_Probe>(find.byType(_Probe));
    expect(probes, isNotEmpty);
    expect(probes.first.color, const Color(0xFFFF0000));
  });

  testWidgets('null builders render the package defaults', (tester) async {
    await pumpWeek(tester, components: bodyComponents(const MultiDayBodyComponents()));

    expect(find.byType(TimeLine), findsOneWidget);
    expect(find.byType(HourLines), findsOneWidget);
    expect(find.byType(DaySeparator), findsWidgets);
  });
}

/// Renders nothing. Carries the colour its builder resolved from the context, so
/// a test can read it back without keying widgets that repeat per day column.
class _Probe extends StatelessWidget {
  const _Probe(this.color);

  final Color? color;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
