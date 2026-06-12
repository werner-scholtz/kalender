import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  // ─── defaultSnapStrategy ─────────────────────────────────────────────────────

  group('defaultSnapStrategy', () {
    final startOfDay = InternalDateTime(2024, 1, 15);

    test('snaps the cursor down to the nearest interval (rounds toward the lower boundary)', () {
      // 00:07 is 7 min in → 7/15 rounds to 0 → snaps back to 00:00.
      final snapped = defaultSnapStrategy(InternalDateTime(2024, 1, 15, 0, 7), startOfDay, 15);
      expect(snapped, equals(InternalDateTime(2024, 1, 15)));
    });

    test('snaps the cursor up to the nearest interval (rounds toward the upper boundary)', () {
      // 00:08 is 8 min in → 8/15 rounds to 1 → snaps forward to 00:15.
      final snapped = defaultSnapStrategy(InternalDateTime(2024, 1, 15, 0, 8), startOfDay, 15);
      expect(snapped, equals(InternalDateTime(2024, 1, 15, 0, 15)));
    });

    test('a cursor already on an interval boundary is unchanged', () {
      final onBoundary = InternalDateTime(2024, 1, 15, 9, 30);
      expect(defaultSnapStrategy(onBoundary, startOfDay, 15), equals(onBoundary));
    });
  });

  // ─── CalendarInteraction.resolveIsImprecise ──────────────────────────────────

  group('CalendarInteraction.resolveIsImprecise', () {
    test('precise mode is never imprecise', () {
      expect(CalendarInteraction(inputMode: InputMode.precise).resolveIsImprecise(), isFalse);
    });

    test('imprecise mode is always imprecise', () {
      expect(CalendarInteraction(inputMode: InputMode.imprecise).resolveIsImprecise(), isTrue);
    });

    test('auto mode follows the platform: mobile → imprecise', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(CalendarInteraction(inputMode: InputMode.auto).resolveIsImprecise(), isTrue);
    });

    test('auto mode follows the platform: desktop → precise', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(CalendarInteraction(inputMode: InputMode.auto).resolveIsImprecise(), isFalse);
    });
  });

  // ─── CalendarInteraction: default gestures depend on platform ────────────────

  group('CalendarInteraction default gestures', () {
    test('mobile defaults to long-press for create/modify', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final interaction = CalendarInteraction();
      expect(interaction.createEventGesture, equals(CreateEventGesture.longPress));
      expect(interaction.modifyEventGesture, equals(CreateEventGesture.longPress));
    });

    test('desktop defaults to tap for create/modify', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final interaction = CalendarInteraction();
      expect(interaction.createEventGesture, equals(CreateEventGesture.tap));
      expect(interaction.modifyEventGesture, equals(CreateEventGesture.tap));
    });

    test('an explicit gesture overrides the platform default', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final interaction = CalendarInteraction(createEventGesture: CreateEventGesture.tap);
      expect(interaction.createEventGesture, equals(CreateEventGesture.tap));
    });
  });

  // ─── CalendarInteraction.copyWith ────────────────────────────────────────────

  group('CalendarInteraction.copyWith', () {
    test('replaces only the provided fields and preserves the rest', () {
      final original = CalendarInteraction(
        allowResizing: true,
        allowRescheduling: true,
        allowEventCreation: true,
        throttleMilliseconds: 16,
        inputMode: InputMode.precise,
        allowHorizontalImpreciseResize: false,
        createEventGesture: CreateEventGesture.tap,
        modifyEventGesture: CreateEventGesture.tap,
      );

      final copy = original.copyWith(
        allowResizing: false,
        throttleMilliseconds: 32,
        inputMode: InputMode.imprecise,
        modifyEventGesture: CreateEventGesture.longPress,
      );

      expect(copy.allowResizing, isFalse);
      expect(copy.throttleMilliseconds, equals(32));
      expect(copy.inputMode, equals(InputMode.imprecise));
      expect(copy.modifyEventGesture, equals(CreateEventGesture.longPress));
      // Untouched fields are preserved.
      expect(copy.allowRescheduling, isTrue);
      expect(copy.allowEventCreation, isTrue);
      expect(copy.allowHorizontalImpreciseResize, isFalse);
      expect(copy.createEventGesture, equals(CreateEventGesture.tap));
    });

    test('copyWith with no arguments preserves every field', () {
      final original = CalendarInteraction(
        allowResizing: false,
        throttleMilliseconds: 99,
        inputMode: InputMode.imprecise,
        createEventGesture: CreateEventGesture.longPress,
      );
      final copy = original.copyWith();
      expect(copy.allowResizing, equals(original.allowResizing));
      expect(copy.throttleMilliseconds, equals(original.throttleMilliseconds));
      expect(copy.inputMode, equals(original.inputMode));
      expect(copy.createEventGesture, equals(original.createEventGesture));
    });
  });

  // ─── CalendarInteraction: equality ───────────────────────────────────────────

  group('CalendarInteraction equality', () {
    CalendarInteraction make() => CalendarInteraction(
          allowResizing: true,
          allowRescheduling: true,
          allowEventCreation: true,
          throttleMilliseconds: 16,
          inputMode: InputMode.precise,
          allowHorizontalImpreciseResize: false,
          createEventGesture: CreateEventGesture.tap,
          modifyEventGesture: CreateEventGesture.tap,
        );

    test('identical configurations are equal with matching hashCodes', () {
      expect(make(), equals(make()));
      expect(make().hashCode, equals(make().hashCode));
    });

    for (final entry in <String, CalendarInteraction Function(CalendarInteraction)>{
      'allowResizing': (i) => i.copyWith(allowResizing: false),
      'allowRescheduling': (i) => i.copyWith(allowRescheduling: false),
      'allowEventCreation': (i) => i.copyWith(allowEventCreation: false),
      'inputMode': (i) => i.copyWith(inputMode: InputMode.imprecise),
      'allowHorizontalImpreciseResize': (i) => i.copyWith(allowHorizontalImpreciseResize: true),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value(make()), isNot(equals(make())));
      });
    }

    // CHARACTERIZATION: == and hashCode currently ignore throttleMilliseconds,
    // createEventGesture and modifyEventGesture, so interactions differing only
    // in those fields compare equal. See the skipped group below for the
    // arguably-desired behaviour.
    test('differing throttleMilliseconds does NOT break equality (current behaviour)', () {
      expect(make().copyWith(throttleMilliseconds: 999), equals(make()));
    });

    test('differing createEventGesture does NOT break equality (current behaviour)', () {
      expect(make().copyWith(createEventGesture: CreateEventGesture.longPress), equals(make()));
    });
  });

  group('CalendarInteraction equality (desired: all copyWith fields participate)', () {
    CalendarInteraction make() =>
        CalendarInteraction(throttleMilliseconds: 16, createEventGesture: CreateEventGesture.tap);

    test('differing throttleMilliseconds should break equality', () {
      expect(make().copyWith(throttleMilliseconds: 999), isNot(equals(make())));
    });

    test('differing createEventGesture should break equality', () {
      expect(make().copyWith(createEventGesture: CreateEventGesture.longPress), isNot(equals(make())));
    });
  },
      skip: 'CalendarInteraction.== / hashCode omit throttleMilliseconds and the gesture fields; '
          'a ValueNotifier<CalendarInteraction> would not notify on those changes. '
          'Un-skip if == is widened to cover every copyWith field.',
  );

  // ─── EventInteraction ────────────────────────────────────────────────────────

  group('EventInteraction', () {
    test('default constructor allows all interactions', () {
      final interaction = EventInteraction();
      expect(interaction.allowStartResize, isTrue);
      expect(interaction.allowEndResize, isTrue);
      expect(interaction.allowRescheduling, isTrue);
    });

    test('fromCanModify(true) enables every interaction', () {
      final interaction = EventInteraction.fromCanModify(true);
      expect(interaction, equals(EventInteraction.allowAll()));
    });

    test('fromCanModify(false) disables every interaction', () {
      final interaction = EventInteraction.fromCanModify(false);
      expect(interaction, equals(EventInteraction.allowNone()));
    });

    test('allowNone disables every interaction', () {
      final interaction = EventInteraction.allowNone();
      expect(interaction.allowStartResize, isFalse);
      expect(interaction.allowEndResize, isFalse);
      expect(interaction.allowRescheduling, isFalse);
    });

    test('allowAll and allowNone are not equal', () {
      expect(EventInteraction.allowAll(), isNot(equals(EventInteraction.allowNone())));
    });

    test('equal configurations share a hashCode', () {
      expect(EventInteraction.allowAll().hashCode, equals(EventInteraction.fromCanModify(true).hashCode));
    });

    for (final entry in <String, EventInteraction>{
      'allowStartResize': EventInteraction(allowStartResize: false),
      'allowEndResize': EventInteraction(allowEndResize: false),
      'allowRescheduling': EventInteraction(allowRescheduling: false),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(EventInteraction())));
      });
    }
  });

  // ─── CalendarSnapping ────────────────────────────────────────────────────────

  group('CalendarSnapping', () {
    test('copyWith replaces only the provided fields', () {
      const original = CalendarSnapping(
        snapIntervalMinutes: 10,
        snapToTimeIndicator: true,
        snapToOtherEvents: true,
        snapRange: Duration(minutes: 15),
      );
      final copy = original.copyWith(snapIntervalMinutes: 30, snapToOtherEvents: false);
      expect(copy.snapIntervalMinutes, equals(30));
      expect(copy.snapToOtherEvents, isFalse);
      expect(copy.snapToTimeIndicator, isTrue);
      expect(copy.snapRange, equals(const Duration(minutes: 15)));
    });

    test('identical configurations are equal with matching hashCodes', () {
      expect(const CalendarSnapping(), equals(const CalendarSnapping()));
      expect(const CalendarSnapping().hashCode, equals(const CalendarSnapping().hashCode));
    });

    for (final entry in <String, CalendarSnapping>{
      'snapIntervalMinutes': const CalendarSnapping(snapIntervalMinutes: 5),
      'snapToTimeIndicator': const CalendarSnapping(snapToTimeIndicator: false),
      'snapToOtherEvents': const CalendarSnapping(snapToOtherEvents: false),
      'snapRange': const CalendarSnapping(snapRange: Duration(minutes: 30)),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const CalendarSnapping())));
      });
    }
  });
}
