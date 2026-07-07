import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart' show ExpandablePageView;

import '../utilities.dart';

/// Regression coverage for #180: the multi-day header's day columns must line up
/// with the body's day columns regardless of how the timeline gutter is
/// customized. Both are driven by a single gutter width, so the body's day area
/// (the [HourLines]) and the header's day area (the [ExpandablePageView] content)
/// must occupy the same horizontal span.
void main() {
  late DefaultEventsController eventsController;
  late CalendarController calendarController;

  setUp(() {
    eventsController = DefaultEventsController();
    calendarController = CalendarController();
  });

  final tiles = TileComponents(tileBuilder: (event, tileRange) => const SizedBox());

  Future<void> pumpWeek(
    WidgetTester tester, {
    CalendarComponents? components,
    TextDirection textDirection = TextDirection.ltr,
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
    await pumpAndSettleWithMaterialApp(tester, Directionality(textDirection: textDirection, child: view));
  }

  double gutterWidth(WidgetTester tester) => tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;

  /// Asserts the header's day area lines up with the body's day area.
  void expectAligned(WidgetTester tester) {
    final bodyDayArea = tester.getRect(find.byType(HourLines));
    final headerDayArea = tester.getRect(find.byType(ExpandablePageView));
    expect(
      headerDayArea.left,
      moreOrLessEquals(bodyDayArea.left, epsilon: 0.5),
      reason: 'Header day columns must start where the body day columns start',
    );
    expect(
      headerDayArea.right,
      moreOrLessEquals(bodyDayArea.right, epsilon: 0.5),
      reason: 'Header day columns must end where the body day columns end',
    );
  }

  CalendarComponents withTimelineStyle(TimelineStyle style) => CalendarComponents(
        multiDayComponentStyles: MultiDayComponentStyles(
          bodyStyles: MultiDayBodyComponentStyles(timelineStyle: style),
        ),
      );

  testWidgets('default timeline: header and body columns align', (tester) async {
    await pumpWeek(tester);
    expectAligned(tester);
  });

  testWidgets('custom stringBuilder shortening labels keeps columns aligned (#180)', (tester) async {
    await pumpWeek(tester, components: withTimelineStyle(TimelineStyle(stringBuilder: (_) => 'X')));

    // The gutter shrank to fit the short label ...
    expect(gutterWidth(tester), lessThan(40), reason: 'Short labels should produce a narrow gutter');
    // ... and the header still lines up with the body (this is what #180 broke).
    expectAligned(tester);
  });

  testWidgets('explicit TimelineStyle.width drives the gutter and stays aligned', (tester) async {
    await pumpWeek(tester, components: withTimelineStyle(const TimelineStyle(width: 100)));

    expect(gutterWidth(tester), moreOrLessEquals(100, epsilon: 0.5));
    expectAligned(tester);
  });

  testWidgets('custom timelineWidth builder drives the gutter and stays aligned', (tester) async {
    await pumpWeek(
      tester,
      components: CalendarComponents(
        multiDayComponents: MultiDayComponents(
          bodyComponents: MultiDayBodyComponents(timelineWidth: (context, timeOfDayRange, style) => 100),
        ),
      ),
    );

    expect(gutterWidth(tester), moreOrLessEquals(100, epsilon: 0.5));
    expectAligned(tester);
  });

  testWidgets('columns stay aligned in right-to-left', (tester) async {
    await pumpWeek(
      tester,
      components: withTimelineStyle(TimelineStyle(stringBuilder: (_) => 'X')),
      textDirection: TextDirection.rtl,
    );
    expectAligned(tester);
  });
}
