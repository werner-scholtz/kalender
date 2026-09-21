// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

void main() {
  void overridePlatform(TargetPlatform? platform) {
    debugDefaultTargetPlatformOverride = platform;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
  }

  group('IntervalSnapStrategy', () {
    final startOfDay = FloatingDateTime(2024, 1, 15);
    FloatingDateTime snap(FloatingDateTime cursor) {
      return kDefaultSnapStrategy.snap(cursorDate: cursor, startOfDay: startOfDay, snapIntervalMinutes: 15);
    }

    test('snaps the cursor down to the nearest interval (rounds toward the lower boundary)', () {
      // 00:07 is 7 min in → 7/15 rounds to 0 → snaps back to 00:00.
      expect(snap(FloatingDateTime(2024, 1, 15, 0, 7)), equals(FloatingDateTime(2024, 1, 15)));
    });

    test('snaps the cursor up to the nearest interval (rounds toward the upper boundary)', () {
      // 00:08 is 8 min in → 8/15 rounds to 1 → snaps forward to 00:15.
      expect(snap(FloatingDateTime(2024, 1, 15, 0, 8)), equals(FloatingDateTime(2024, 1, 15, 0, 15)));
    });

    test('a cursor already on an interval boundary is unchanged', () {
      final onBoundary = FloatingDateTime(2024, 1, 15, 9, 30);
      expect(snap(onBoundary), equals(onBoundary));
    });

    test('the default strategy is the interval one', () {
      expect(kDefaultSnapStrategy, equals(const EventSnapStrategy.interval()));
    });
  });

  group('NoSnapStrategy', () {
    test('returns the cursor unchanged', () {
      final cursor = FloatingDateTime(2024, 1, 15, 0, 7);
      final snapped = const EventSnapStrategy.none().snap(
        cursorDate: cursor,
        startOfDay: FloatingDateTime(2024, 1, 15),
        snapIntervalMinutes: 15,
      );
      expect(snapped, equals(cursor));
    });

    test('two instances compare equal, and differ from the interval strategy', () {
      expect(const EventSnapStrategy.none(), equals(const EventSnapStrategy.none()));
      expect(const EventSnapStrategy.none(), isNot(equals(const EventSnapStrategy.interval())));
    });
  });

  group('KalenderInteraction.resolveIsImprecise', () {
    for (final (mode, platform, imprecise) in [
      (InputMode.precise, null, false),
      (InputMode.imprecise, null, true),
      (InputMode.auto, TargetPlatform.android, true),
      (InputMode.auto, TargetPlatform.macOS, false),
    ]) {
      test('${mode.name} mode on ${platform?.name ?? 'any platform'} is ${imprecise ? 'imprecise' : 'precise'}', () {
        overridePlatform(platform);
        expect(KalenderInteraction(inputMode: mode).resolveIsImprecise(), imprecise);
      });
    }
  });

  group('KalenderInteraction default gestures', () {
    for (final (platform, gesture) in [
      (TargetPlatform.iOS, EventInteractionGesture.longPress),
      (TargetPlatform.linux, EventInteractionGesture.tap),
    ]) {
      test('${platform.name} defaults to ${gesture.name} for create/modify', () {
        overridePlatform(platform);
        final interaction = KalenderInteraction();
        expect(interaction.createEventGesture, equals(gesture));
        expect(interaction.modifyEventGesture, equals(gesture));
      });
    }

    test('an explicit gesture overrides the platform default', () {
      overridePlatform(TargetPlatform.android);
      final interaction = KalenderInteraction(createEventGesture: EventInteractionGesture.tap);
      expect(interaction.createEventGesture, equals(EventInteractionGesture.tap));
    });
  });

  group('KalenderInteraction.copyWith', () {
    test('replaces only the provided fields and preserves the rest', () {
      final original = KalenderInteraction(
        allowResizing: true,
        allowRescheduling: true,
        allowEventCreation: true,
        inputMode: InputMode.precise,
        allowHorizontalImpreciseResize: false,
        createEventGesture: EventInteractionGesture.tap,
        modifyEventGesture: EventInteractionGesture.tap,
      );

      final copy = original.copyWith(
        allowResizing: false,
        inputMode: InputMode.imprecise,
        modifyEventGesture: EventInteractionGesture.longPress,
      );

      expect(copy.allowResizing, isFalse);
      expect(copy.inputMode, equals(InputMode.imprecise));
      expect(copy.modifyEventGesture, equals(EventInteractionGesture.longPress));
      expect(copy.allowRescheduling, isTrue);
      expect(copy.allowEventCreation, isTrue);
      expect(copy.allowHorizontalImpreciseResize, isFalse);
      expect(copy.createEventGesture, equals(EventInteractionGesture.tap));
    });

    test('copyWith with no arguments preserves every field', () {
      final original = KalenderInteraction(
        allowResizing: false,
        inputMode: InputMode.imprecise,
        createEventGesture: EventInteractionGesture.longPress,
      );
      final copy = original.copyWith();
      expect(copy.allowResizing, equals(original.allowResizing));
      expect(copy.inputMode, equals(original.inputMode));
      expect(copy.createEventGesture, equals(original.createEventGesture));
    });
  });

  group('KalenderInteraction equality', () {
    KalenderInteraction make() => KalenderInteraction(
      allowResizing: true,
      allowRescheduling: true,
      allowEventCreation: true,
      inputMode: InputMode.precise,
      allowHorizontalImpreciseResize: false,
      createEventGesture: EventInteractionGesture.tap,
      modifyEventGesture: EventInteractionGesture.tap,
    );

    test('identical configurations are equal with matching hashCodes', () {
      expect(make(), equals(make()));
      expect(make().hashCode, equals(make().hashCode));
    });

    for (final entry in <String, KalenderInteraction Function(KalenderInteraction)>{
      'allowResizing': (i) => i.copyWith(allowResizing: false),
      'allowRescheduling': (i) => i.copyWith(allowRescheduling: false),
      'allowEventCreation': (i) => i.copyWith(allowEventCreation: false),
      'inputMode': (i) => i.copyWith(inputMode: InputMode.imprecise),
      'allowHorizontalImpreciseResize': (i) => i.copyWith(allowHorizontalImpreciseResize: true),
      'createEventGesture': (i) => i.copyWith(createEventGesture: EventInteractionGesture.longPress),
      'modifyEventGesture': (i) => i.copyWith(modifyEventGesture: EventInteractionGesture.longPress),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value(make()), isNot(equals(make())));
        expect(entry.value(make()).hashCode, isNot(equals(make().hashCode)));
      });
    }
  });

  group('EventInteraction', () {
    test('default constructor allows all interactions', () {
      expect(EventInteraction(), equals(EventInteraction.allowAll()));
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
      expect(
        EventInteraction.allowNone(),
        equals(EventInteraction(allowStartResize: false, allowEndResize: false, allowRescheduling: false)),
      );
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

  group('KalenderSnapping', () {
    test('copyWith replaces only the provided fields', () {
      const original = KalenderSnapping(
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

    test('copyWith preserves a custom eventSnapStrategy', () {
      const original = KalenderSnapping(eventSnapStrategy: EventSnapStrategy.none());
      final copy = original.copyWith(snapIntervalMinutes: 30);
      expect(copy.eventSnapStrategy, equals(const EventSnapStrategy.none()));
    });

    test('copyWith replaces eventSnapStrategy when given one', () {
      const original = KalenderSnapping();
      final copy = original.copyWith(eventSnapStrategy: const EventSnapStrategy.none());
      expect(copy.eventSnapStrategy, equals(const EventSnapStrategy.none()));
    });

    test('identical configurations are equal with matching hashCodes', () {
      expect(const KalenderSnapping(), equals(const KalenderSnapping()));
      expect(const KalenderSnapping().hashCode, equals(const KalenderSnapping().hashCode));
    });

    for (final entry in <String, KalenderSnapping>{
      'snapIntervalMinutes': const KalenderSnapping(snapIntervalMinutes: 5),
      'snapToTimeIndicator': const KalenderSnapping(snapToTimeIndicator: false),
      'snapToOtherEvents': const KalenderSnapping(snapToOtherEvents: false),
      'snapRange': const KalenderSnapping(snapRange: Duration(minutes: 30)),
      'eventSnapStrategy': const KalenderSnapping(eventSnapStrategy: EventSnapStrategy.none()),
    }.entries) {
      test('differing ${entry.key} breaks equality', () {
        expect(entry.value, isNot(equals(const KalenderSnapping())));
        expect(entry.value.hashCode, isNot(equals(const KalenderSnapping().hashCode)));
      });
    }
  });
}
