import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// The three strategies were functions until 0.26.0. A configuration holding one
/// written as an inline closure was a new value on every build, so the calendar
/// read every rebuild as a change. As classes with value equality they compare
/// by what they do rather than by which closure instance was passed.
void main() {
  group('EventLayoutStrategy', () {
    test('two of the same kind are equal, with matching hashCodes', () {
      expect(const EventLayoutStrategy.overlap(), equals(const EventLayoutStrategy.overlap()));
      expect(
        const EventLayoutStrategy.overlap().hashCode,
        equals(const EventLayoutStrategy.overlap().hashCode),
      );
    });

    test('the two built-ins are not equal to each other', () {
      expect(const EventLayoutStrategy.overlap(), isNot(equals(const EventLayoutStrategy.sideBySide())));
    });

    test('the named factory and the public class are the same value', () {
      expect(const EventLayoutStrategy.overlap(), equals(const OverlapLayoutStrategy()));
      expect(const EventLayoutStrategy.sideBySide(), equals(const SideBySideLayoutStrategy()));
    });

    test('overlap is the default', () {
      expect(defaultEventLayoutStrategy, equals(const EventLayoutStrategy.overlap()));
    });
  });

  group('MultiDayLayoutStrategy', () {
    test('two of the same kind are equal, with matching hashCodes', () {
      expect(const MultiDayLayoutStrategy.byDuration(), equals(const MultiDayLayoutStrategy.byDuration()));
      expect(
        const MultiDayLayoutStrategy.byDuration().hashCode,
        equals(const MultiDayLayoutStrategy.byDuration().hashCode),
      );
    });

    test('byDuration is the default', () {
      expect(defaultMultiDayLayoutStrategy, equals(const MultiDayLayoutStrategy.byDuration()));
    });

    test('a custom strategy is not equal to the built-in one', () {
      expect(const _ReverseStrategy(), isNot(equals(const MultiDayLayoutStrategy.byDuration())));
    });
  });

  group('EventSnapStrategy', () {
    test('two of the same kind are equal, with matching hashCodes', () {
      expect(const EventSnapStrategy.interval(), equals(const EventSnapStrategy.interval()));
      expect(const EventSnapStrategy.interval().hashCode, equals(const EventSnapStrategy.interval().hashCode));
    });

    test('the two built-ins are not equal to each other', () {
      expect(const EventSnapStrategy.interval(), isNot(equals(const EventSnapStrategy.none())));
    });
  });

  // The point of the conversion: a configuration built fresh on each build, as a
  // build method does, compares equal to its predecessor.
  group('configurations built twice', () {
    test('MultiDayBodyConfiguration with a layout strategy is equal', () {
      MultiDayBodyConfiguration build() {
        return const MultiDayBodyConfiguration(eventLayoutStrategy: EventLayoutStrategy.sideBySide());
      }

      expect(build(), equals(build()));
      expect(build().hashCode, equals(build().hashCode));
    });

    test('MonthBodyConfiguration with a multi-day strategy is equal', () {
      MonthBodyConfiguration build() {
        return const MonthBodyConfiguration(multiDayLayoutStrategy: MultiDayLayoutStrategy.byDuration());
      }

      expect(build(), equals(build()));
      expect(build().hashCode, equals(build().hashCode));
    });

    test('CalendarSnapping with a snap strategy is equal', () {
      CalendarSnapping build() => const CalendarSnapping(eventSnapStrategy: EventSnapStrategy.none());

      expect(build(), equals(build()));
      expect(build().hashCode, equals(build().hashCode));
    });
  });

  // The other half of the contract: a change still has to reach the calendar.
  group('changing only the strategy breaks equality', () {
    test('eventLayoutStrategy', () {
      expect(
        const MultiDayBodyConfiguration(eventLayoutStrategy: EventLayoutStrategy.sideBySide()),
        isNot(equals(const MultiDayBodyConfiguration())),
      );
    });

    test('multiDayLayoutStrategy', () {
      expect(
        const MonthBodyConfiguration(multiDayLayoutStrategy: _ReverseStrategy()),
        isNot(equals(const MonthBodyConfiguration())),
      );
    });

    test('eventSnapStrategy', () {
      expect(
        const CalendarSnapping(eventSnapStrategy: EventSnapStrategy.none()),
        isNot(equals(const CalendarSnapping())),
      );
    });
  });
}

/// A strategy that reverses the event order, used only to be distinguishable
/// from the built-in one.
class _ReverseStrategy extends MultiDayLayoutStrategy {
  const _ReverseStrategy();

  @override
  MultiDayLayoutFrame generateFrame({
    required InternalDateTimeRange visibleDateTimeRange,
    required List<CalendarEvent> events,
    required TextDirection textDirection,
    required Location? location,
    required MultiDayLayoutFrameCache? cache,
  }) {
    return defaultMultiDayFrameGenerator(
      visibleDateTimeRange: visibleDateTimeRange,
      events: events.reversed.toList(),
      textDirection: textDirection,
      location: location,
      cache: cache,
    );
  }

  @override
  bool operator ==(Object other) => other is _ReverseStrategy;

  @override
  int get hashCode => (_ReverseStrategy).hashCode;
}
