import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/layout_delegates/event_layout_delegate.dart';

/// The delegate caches layout data in a map keyed by event hash, and
/// `CustomMultiChildLayout` asserts when a child is not laid out. So the
/// returned list has to hold one entry per event even when two events share a
/// key, otherwise a child is silently dropped and layout throws.
void main() {
  final date = InternalDateTime(2024, 1, 1);

  CalendarEvent event({String? id, int hour = 9}) {
    return CalendarEvent(
      id: id,
      dateTimeRange: DateTimeRange(
        start: DateTime.utc(2024, 1, 1, hour),
        end: DateTime.utc(2024, 1, 1, hour + 1),
      ),
    );
  }

  OverlapLayoutDelegate delegateFor(List<CalendarEvent> events, {EventLayoutDelegateCache? cache}) {
    return OverlapLayoutDelegate(
      events: events,
      heightPerMinute: 1,
      date: date,
      location: null,
      timeOfDayRange: TimeOfDayRange.allDay(),
      minimumTileHeight: null,
      layoutCache: cache ?? EventLayoutDelegateCache(),
    );
  }

  const size = Size(300, 24 * 60);

  test('every event gets layout data, including distinct ones', () {
    final delegate = delegateFor([event(hour: 9), event(hour: 11), event(hour: 13)]);
    expect(delegate.calculateVerticalLayoutData(size), hasLength(3));
  });

  test('two events sharing a hash still get one entry each', () {
    // Same id, same range, so identical hashCodes and a single cache entry.
    final duplicate = event(id: 'same');
    final delegate = delegateFor([duplicate, event(id: 'same')]);

    final data = delegate.calculateVerticalLayoutData(size);
    expect(data, hasLength(2), reason: 'a shared cache entry must not drop a child');
    expect(data.map((d) => d.id).toSet(), {0, 1}, reason: 'each child needs its own id to be laid out');
  });

  test('a subclass whose hashCode ignores the id does not lose children', () {
    // Legal Dart, and normally only makes hash lookups slower. Here it used to
    // collapse every event into one entry.
    final delegate = delegateFor([
      _ConstantHashEvent(hour: 9),
      _ConstantHashEvent(hour: 11),
      _ConstantHashEvent(hour: 13),
    ]);

    final data = delegate.calculateVerticalLayoutData(size);
    expect(data, hasLength(3));
    expect(data.map((d) => d.id).toSet(), {0, 1, 2});
  });

  test('reusing a warm cache still returns one entry per child', () {
    final cache = EventLayoutDelegateCache();
    final events = [event(hour: 9), event(hour: 11)];

    delegateFor(events, cache: cache).calculateVerticalLayoutData(size);
    final second = delegateFor(events, cache: cache).calculateVerticalLayoutData(size);

    expect(second, hasLength(2));
    expect(second.map((d) => d.id).toSet(), {0, 1});
  });
}

/// Hashes to a constant, so every instance collides.
class _ConstantHashEvent extends CalendarEvent {
  _ConstantHashEvent({required int hour})
      : super(
          dateTimeRange: DateTimeRange(
            start: DateTime.utc(2024, 1, 1, hour),
            end: DateTime.utc(2024, 1, 1, hour + 1),
          ),
        );

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other);
}
