import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Both classes reach the calendar through a [ValueNotifier], which uses `==`
/// to decide whether to notify. A field left out of `==` therefore never
/// reaches the calendar when it is the only thing that changed.
void main() {
  group('CalendarInteraction', () {
    CalendarInteraction base() => CalendarInteraction(
          allowResizing: true,
          allowRescheduling: true,
          allowEventCreation: true,
          throttleMilliseconds: 16,
          inputMode: InputMode.precise,
          allowHorizontalImpreciseResize: false,
          createEventGesture: CreateEventGesture.tap,
          modifyEventGesture: CreateEventGesture.tap,
        );

    test('equal when every field matches', () {
      expect(base(), base());
      expect(base().hashCode, base().hashCode);
    });

    final changes = <String, CalendarInteraction Function(CalendarInteraction)>{
      'allowResizing': (i) => i.copyWith(allowResizing: false),
      'allowRescheduling': (i) => i.copyWith(allowRescheduling: false),
      'allowEventCreation': (i) => i.copyWith(allowEventCreation: false),
      'throttleMilliseconds': (i) => i.copyWith(throttleMilliseconds: 32),
      'inputMode': (i) => i.copyWith(inputMode: InputMode.imprecise),
      'allowHorizontalImpreciseResize': (i) => i.copyWith(allowHorizontalImpreciseResize: true),
      'createEventGesture': (i) => i.copyWith(createEventGesture: CreateEventGesture.longPress),
      'modifyEventGesture': (i) => i.copyWith(modifyEventGesture: CreateEventGesture.longPress),
    };

    for (final entry in changes.entries) {
      test('unequal when ${entry.key} differs', () {
        final changed = entry.value(base());
        expect(changed, isNot(base()));
        expect(changed.hashCode, isNot(base().hashCode));
      });
    }

    test('copyWith keeps the fields it is not given', () {
      final copy = base().copyWith(throttleMilliseconds: 32);
      expect(copy.throttleMilliseconds, 32);
      expect(copy.allowResizing, base().allowResizing);
      expect(copy.inputMode, base().inputMode);
      expect(copy.createEventGesture, base().createEventGesture);
      expect(copy.modifyEventGesture, base().modifyEventGesture);
    });
  });

  group('MultiDayHeaderConfiguration', () {
    const base = MultiDayHeaderConfiguration(
      showTiles: true,
      tileHeight: 24,
      maximumNumberOfVerticalEvents: 3,
      eventPadding: EdgeInsets.all(1),
      allowSingleDayEvents: false,
    );

    test('equal when every field matches', () {
      expect(
        base,
        const MultiDayHeaderConfiguration(
          showTiles: true,
          tileHeight: 24,
          maximumNumberOfVerticalEvents: 3,
          eventPadding: EdgeInsets.all(1),
          allowSingleDayEvents: false,
        ),
      );
    });

    final changes = <String, MultiDayHeaderConfiguration Function()>{
      'showTiles': () => base.copyWith(showTiles: false),
      'tileHeight': () => base.copyWith(tileHeight: 48),
      'maximumNumberOfVerticalEvents': () => base.copyWith(maximumNumberOfVerticalEvents: 5),
      'eventPadding': () => base.copyWith(eventPadding: const EdgeInsets.all(4)),
      'allowSingleDayEvents': () => base.copyWith(allowSingleDayEvents: true),
    };

    for (final entry in changes.entries) {
      test('unequal when ${entry.key} differs', () {
        final changed = entry.value();
        expect(changed, isNot(base));
        expect(changed.hashCode, isNot(base.hashCode));
      });
    }
  });
}
