// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/internal_components/expandable_page_view.dart' show ExpandablePageView;

import '../utilities.dart';

/// #180: the header's day area ([ExpandablePageView]) spans the same columns as the body's day area ([HourLines]),
/// however the timeline gutter is customized.
void main() {
  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.week(
        displayRange: KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 2)),
      ),
    );
  });

  final tiles = TileComponents(tileBuilder: (context, event, tileRange) => const SizedBox());

  Future<void> pumpWeek(
    WidgetTester tester, {
    KalenderComponents? components,
    KalenderThemeData? theme,
    TextDirection textDirection = TextDirection.ltr,
    Locale? locale,
  }) async {
    final view = KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      components: components,
      locale: locale,
      views: [
        MultiDayViewParts(
          header: MultiDayHeader(tileComponents: tiles),
          body: MultiDayBody(tileComponents: tiles),
        ),
      ],
    );
    await pumpAndSettleWithMaterialApp(
      tester,
      Directionality(
        textDirection: textDirection,
        child: theme == null ? view : KalenderTheme(data: theme, child: view),
      ),
    );
  }

  double gutterWidth(WidgetTester tester) => tester.getSize(find.byKey(MultiDayBody.timelineKey)).width;

  /// Asserts the header's day area lines up with the body's day area.
  void expectAligned(WidgetTester tester) {
    final bodyDayArea = tester.getRect(find.byType(HourLines));
    final headerDayArea = tester.getRect(find.byType(ExpandablePageView));
    expect(headerDayArea.left, moreOrLessEquals(bodyDayArea.left, epsilon: 0.5));
    expect(headerDayArea.right, moreOrLessEquals(bodyDayArea.right, epsilon: 0.5));
  }

  KalenderComponents withTimelineStringBuilder(KalenderTimeStringBuilder builder) => KalenderComponents(
    multiDayComponents: MultiDayComponents(bodyComponents: MultiDayBodyComponents(timelineStringBuilder: builder)),
  );

  /// The label of the timeline entry for [hour]:00.
  String labelAt(WidgetTester tester, int hour) {
    return tester.widget<Text>(find.byKey(TimeLine.getTimeKey(hour, 0)).first).data!;
  }

  testWidgets('default timeline: header and body columns align', (tester) async {
    await pumpWeek(tester);
    expectAligned(tester);
  });

  testWidgets('custom stringBuilder shortening labels keeps columns aligned (#180)', (tester) async {
    await pumpWeek(tester, components: withTimelineStringBuilder((context, time) => 'X'));

    expect(gutterWidth(tester), lessThan(40));
    expectAligned(tester);
  });

  testWidgets('measures every label, so the widest hour fits even when it is not 23:59', (tester) async {
    // A string builder whose widest output is at noon, not at 23:59. Sampling
    // only 23:59 (which here returns the short 'x') would under-size the gutter
    // and clip the noon label. Measuring all labels must accommodate it.
    const wide = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'; // 40 chars
    String labels(BuildContext context, KalenderTime time) => time.hour == 12 ? wide : 'x';

    await pumpWeek(tester, components: withTimelineStringBuilder(labels));

    expect(gutterWidth(tester), greaterThan(150));
    expectAligned(tester);
  });

  final fixedWidths = <({String name, KalenderThemeData? theme, KalenderComponents? components})>[
    (
      name: 'explicit TimelineStyle.width',
      theme: const KalenderThemeData(timelineStyle: TimelineStyle(width: 100)),
      components: null,
    ),
    (
      name: 'custom timelineWidth builder',
      theme: null,
      components: KalenderComponents(
        multiDayComponents: MultiDayComponents(
          bodyComponents: MultiDayBodyComponents(timelineWidth: (context, timeOfDayRange) => 100),
        ),
      ),
    ),
  ];

  for (final c in fixedWidths) {
    testWidgets('${c.name} drives the gutter and stays aligned', (tester) async {
      await pumpWeek(tester, theme: c.theme, components: c.components);

      expect(gutterWidth(tester), moreOrLessEquals(100, epsilon: 0.5));
      expectAligned(tester);
    });
  }

  testWidgets('columns stay aligned in right-to-left', (tester) async {
    await pumpWeek(
      tester,
      components: withTimelineStringBuilder((context, time) => 'X'),
      textDirection: TextDirection.rtl,
    );
    expectAligned(tester);
  });

  // The calendar's own locale, which is not necessarily the app's, was not
  // reachable from a custom label before it was handed a BuildContext.
  testWidgets('the string builder receives a context it can read the calendar locale from', (tester) async {
    await initializeDateFormatting('de_DE');
    await pumpWeek(
      tester,
      components: withTimelineStringBuilder((context, time) => '${context.kalenderLocale}'),
      locale: const Locale('de', 'DE'),
    );

    expect(labelAt(tester, 1), 'de_DE');
  });
}
