// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

// The input for `fix_range_members.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

FloatingDateTimeRange? controllerRange(KalenderController c) => c.internalDateTimeRange.value;
FloatingDateTimeRange? controllerRangeFromDevRelease(KalenderController c) => c.floatingRange.value;
FloatingDateTime eventStart(KalenderEvent e) => e.internalStart();
FloatingDateTime eventEnd(KalenderEvent e) => e.internalEnd();
FloatingDateTimeRange eventRange(KalenderEvent e) => e.internalRange();
FloatingDateTimeRange? viewRange(ViewController c) => c.internalVisibleRange.value;
FloatingDateTimeRange? highlighted(ScheduleViewController c) => c.highlightedDateTimeRange.value;

Iterable<KalenderEvent> events(EventsController c, FloatingDateTimeRange r, MultiDayRule rule) =>
    c.eventsFromDateTimeRange(r, multiDayRule: rule);
Set<String> ids(EventStore s, FloatingDateTimeRange r) => s.eventIdsFromDateTimeRange(r, null);

FloatingDateTimeRange fromIndex(PageIndexCalculator p) => p.dateTimeRangeFromIndex(0, null);
FloatingDateTimeRange fromDate(PageIndexCalculator p, FloatingDateTime d) => p.dateTimeRangeFromDate(d, null);
FloatingDateTimeRange whole(PageIndexCalculator p) => p.internalRange(null);

FloatingDateTimeRange? onDate(FloatingDateTimeRange r, FloatingDateTime d) => r.dateTimeRangeOnDate(d);

FloatingDateTimeRange handleRange(ResizeHandleDetails d) => d.dateTimeRange;
FloatingDateTimeRange frameRange(MultiDayLayoutFrame f) => f.dateTimeRange;

MultiDayLayoutFrame frame(FloatingDateTimeRange r) => MultiDayLayoutFrame(
      dateTimeRange: r,
      events: const [],
      layoutInfo: const [],
      totalNumberOfRows: 0,
      columnRowMap: const {},
      textDirection: TextDirection.ltr,
    );

Widget highlight(FloatingDateTime date, ValueNotifier<FloatingDateTimeRange?> r, Widget child) =>
    ScheduleTileHighlight(date: date, dateTimeRange: r, child: child);

MultiDayLayoutFrame generated(FloatingDateTimeRange r, Location? location) => defaultMultiDayFrameGenerator(
      visibleDateTimeRange: r,
      events: const [],
      textDirection: TextDirection.ltr,
      location: location,
    );

MultiDayLayout layout(FloatingDateTimeRange r) => MultiDayLayout(
      dateTimeRange: r,
      layoutInfo: const [],
      numberOfRows: 1,
      tileHeight: 24,
    );

Widget positionList(FloatingDateTimeRange r, ScheduleBodyConfiguration config) => SchedulePositionList(
      configuration: config,
      dateTimeRange: r,
      currentPage: 0,
      paginated: false,
    );

class CustomStrategy extends MultiDayLayoutStrategy {
  const CustomStrategy();

  @override
  MultiDayLayoutFrame generateFrame({
    required FloatingDateTimeRange visibleDateTimeRange,
    required List<KalenderEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    return defaultMultiDayFrameGenerator(
      visibleDateTimeRange: visibleDateTimeRange,
      events: events,
      textDirection: textDirection,
      location: location,
      cache: cache,
    );
  }
}

MultiDayLayoutFrame throughBase(MultiDayLayoutStrategy strategy, FloatingDateTimeRange r) => strategy.generateFrame(
      visibleDateTimeRange: r,
      events: const [],
      textDirection: TextDirection.ltr,
      location: null,
      cache: null,
    );

FloatingDateTimeRange fromStart(DragTargetUtilities<StatefulWidget> u, FloatingDateTimeRange r, DateTime d) =>
    u.calculateDateTimeRangeFromStart(r, d);
FloatingDateTimeRange fromEnd(DragTargetUtilities<StatefulWidget> u, FloatingDateTimeRange r, DateTime d) =>
    u.calculateDateTimeRangeFromEnd(r, d);
FloatingDateTimeRange tileRange(EventTileUtils u, BuildContext context) => u.internalTileRange(context);

ValueNotifier<FloatingDateTimeRange?> highlightRange(ScheduleTileHighlight h) => h.dateTimeRange;
FloatingDateTimeRange layoutRange(MultiDayLayout l) => l.dateTimeRange;
FloatingDateTimeRange positionListRange(SchedulePositionList p) => p.dateTimeRange;

ResizeHandleDetails handleDetails(KalenderEvent e, KalenderInteraction i, FloatingDateTimeRange r) => ResizeHandleDetails(
      event: e,
      interaction: i,
      dateTimeRange: r,
      size: Size.zero,
      axis: Axis.vertical,
      isImprecise: false,
    );

Widget overlayTile(KalenderEvent e, TileComponents c, FloatingDateTimeRange r) => MultiDayEventOverlayTile(
      event: e,
      tileComponents: c,
      dateTimeRange: r,
      resizeAxis: null,
      dismissOverlay: null,
    );

Widget monthWeek(FloatingDateTimeRange r, HorizontalConfiguration c, ViewController v) =>
    MonthWeek(internalRange: r, configuration: c, viewController: v);
FloatingDateTimeRange monthWeekRange(MonthWeek w) => w.internalRange;

typedef Visible = ValueNotifier<FloatingDateTimeRange?>;
typedef Events = ValueNotifier<Set<KalenderEvent>>;

MonthViewController month(MonthViewConfiguration c, Visible r, Events e) =>
    MonthViewController(viewConfiguration: c, internalVisibleRange: r, visibleEvents: e);
MultiDayViewController multiDay(MultiDayViewConfiguration c, Visible r, Events e) =>
    MultiDayViewController(viewConfiguration: c, internalVisibleRange: r, visibleEvents: e);
ScheduleViewController continuous(ScheduleViewConfiguration c, Visible r, Events e, FloatingDateTime d) =>
    ContinuousScheduleViewController(viewConfiguration: c, internalVisibleRange: r, visibleEvents: e, initialDate: d);
ScheduleViewController paginated(ScheduleViewConfiguration c, Visible r, Events e, FloatingDateTime d) =>
    PaginatedScheduleViewController(viewConfiguration: c, internalVisibleRange: r, visibleEvents: e, initialDate: d);
