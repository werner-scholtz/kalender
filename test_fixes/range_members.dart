// The input for `fix_range_members.yaml`. Run `dart fix --compare-to-golden test_fixes`.

import 'package:flutter/widgets.dart';
import 'package:kalender/kalender.dart';

FloatingDateTimeRange? controllerRange(KalenderController c) => c.internalDateTimeRange.value;
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
