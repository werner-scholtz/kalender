// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';

final year2025DisplayRange = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));

const locationsToTest = ['Etc/UTC', 'Africa/Johannesburg', 'America/New_York', 'Europe/London', 'Australia/Sydney'];

final datesToTest = [
  DateTime.now(),
  // America/New_York
  DateTime(2020, 3, 8, 2), // 2020	Sunday, 8 March, 02:00	Sunday, 1 November, 02:00
  DateTime(2020, 11, 1, 2),
  DateTime(2021, 3, 14, 2), // 2021	Sunday, 14 March, 02:00	Sunday, 7 November, 02:00
  DateTime(2021, 11, 7, 2),
  DateTime(2022, 3, 13, 2), // 2022	Sunday, 13 March, 02:00	Sunday, 6 November, 02:00
  DateTime(2022, 11, 6, 2),
  DateTime(2023, 3, 12, 2), // 2023	Sunday, 12 March, 02:00	Sunday, 5 November, 02:00
  DateTime(2023, 11, 5, 2),
  DateTime(2024, 3, 10, 2), // 2024	Sunday, 10 March, 02:00	Sunday, 3 November, 02:00
  DateTime(2024, 11, 3, 2),
  DateTime(2025, 3, 9, 2), // 2025	Sunday, 9 March, 02:00	Sunday, 2 November, 02:00
  DateTime(2025, 11, 2, 2),

  // Europe/London
  DateTime(2020, 3, 29, 1), // 2020	Sunday, 29 March, 01:00	Sunday, 25 October, 02:00
  DateTime(2020, 10, 25, 2),
  DateTime(2021, 3, 28, 1), // 2021	Sunday, 28 March, 01:00	Sunday, 31 October, 02:00
  DateTime(2021, 10, 31, 2),
  DateTime(2022, 3, 27, 1), // 2022	Sunday, 27 March, 01:00	Sunday, 30 October, 02:00
  DateTime(2022, 10, 30, 2),
  DateTime(2023, 3, 26, 1), // 2023	Sunday, 26 March, 01:00	Sunday, 29 October, 02:00
  DateTime(2023, 10, 29, 2),
  DateTime(2024, 3, 31, 1), // 2024	Sunday, 31 March, 01:00	Sunday, 27 October, 02:00
  DateTime(2024, 10, 27, 2),
  DateTime(2025, 3, 30, 1), // 2025	Sunday, 30 March, 01:00	Sunday, 26 October, 02:00
  DateTime(2025, 10, 26, 2),

  // Australia/Sydney
  DateTime(2020, 4, 5, 3), // 2020 Sunday, 5 April, 03:00	Sunday, 4 October, 02:00
  DateTime(2020, 10, 4, 2),
  DateTime(2021, 4, 4, 3), // 2021 Sunday, 4 April, 03:00	Sunday, 3 October, 02:00
  DateTime(2021, 10, 3, 2),
  DateTime(2022, 4, 3, 3), // 2022 Sunday, 3 April, 03:00	Sunday, 2 October, 02:00
  DateTime(2022, 10, 2, 2),
  DateTime(2023, 4, 2, 3), // 2023 Sunday, 2 April, 03:00	Sunday, 1 October, 02:00
  DateTime(2023, 10, 1, 2),
  DateTime(2024, 4, 7, 3), // 2024 Sunday, 7 April, 03:00	Sunday, 6 October, 02:00
  DateTime(2024, 10, 6, 2),
  DateTime(2025, 4, 6, 3), // 2025 Sunday, 6 April, 03:00	Sunday, 5 October, 02:00
  DateTime(2025, 10, 5, 2),
];

/// Runs the given [body] with the given timezone and [datesToTest].
void testWithTimeZones({required void Function(String timezone, Iterable<DateTime> testDates) body}) {
  final timezone = Platform.environment['TZ'] ?? 'UTC';
  return group(timezone, () {
    final isUtc = timezone == 'UTC';
    final testDates = isUtc ? datesToTest.map((e) => e.toUtc()) : datesToTest;
    body(timezone, testDates);
  });
}

/// Precise input with tap gestures, whatever platform the test runs as.
final kPreciseInteraction = KalenderInteraction(
  inputMode: InputMode.precise,
  createEventGesture: EventInteractionGesture.tap,
  modifyEventGesture: EventInteractionGesture.tap,
);

MaterialApp wrapWithMaterialApp(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

Future<void> pumpAndSettleWithMaterialApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(wrapWithMaterialApp(child));
  await tester.pumpAndSettle();
}

/// Pumps a [KalenderView] with [pumpAndSettleWithMaterialApp].
Future<void> pumpKalender(
  WidgetTester tester, {
  required EventsController eventsController,
  required KalenderController kalenderController,
  required ViewConfiguration viewConfiguration,
  KalenderCallbacks? callbacks,
  KalenderComponents? components,
  Widget? header,
  Widget? body,
  Location? location,
}) {
  return pumpAndSettleWithMaterialApp(
    tester,
    KalenderView(
      eventsController: eventsController,
      kalenderController: kalenderController,
      viewConfiguration: viewConfiguration,
      callbacks: callbacks,
      components: components,
      header: header,
      body: body,
      location: location,
    ),
  );
}

class TestProvider extends StatelessWidget {
  final Widget child;
  final KalenderController kalenderController;
  final EventsController eventsController;
  final KalenderCallbacks? callbacks;
  final TileComponents tileComponents;
  final ValueNotifier<double>? heightPerMinute;
  final Locale? locale;
  final Location? location;

  const TestProvider({
    super.key,
    required this.child,
    required this.kalenderController,
    required this.eventsController,
    required this.tileComponents,
    this.callbacks,
    this.heightPerMinute,
    this.locale,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return EventsControllerProvider(
      eventsController: eventsController,
      child: KalenderControllerProvider(
        notifier: kalenderController,
        child: Components(
          components: const KalenderComponents(),
          child: Interaction(
            notifier: ValueNotifier(KalenderInteraction()),
            child: Snapping(
              notifier: ValueNotifier(const KalenderSnapping()),
              child: HeightPerMinute(
                notifier: heightPerMinute ?? ValueNotifier(0.7),
                child: Callbacks(
                  callbacks: callbacks ?? const KalenderCallbacks(),
                  child: TileComponentProvider(
                    tileComponents: tileComponents,
                    child: LocaleProvider(
                      locale: locale,
                      child: LocationProvider(notifier: ValueNotifier(location), child: child),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension WidgetTesterUtils on WidgetTester {
  /// Moves [gesture] to the centre of [tile] and waits for the frame to settle.
  ///
  /// Resize handles are only shown on hover for non-mobile devices, so tests
  /// that check for them must hover over the tile first.
  Future<void> hoverOn(Finder tile, TestGesture gesture) async {
    await pump();
    await gesture.moveTo(getCenter(tile));
    await pumpAndSettle();
  }

  /// Long-presses at [startLocation], drags by [offset] and releases, for [LongPressDraggable] widgets.
  Future<void> longPressDrag(Offset startLocation, Offset offset) async {
    final gesture = await startGesture(startLocation);
    await pump(const Duration(milliseconds: 500));
    await gesture.moveBy(offset);
    await pumpAndSettle();
    await gesture.up();
    await pumpAndSettle();
  }

  Future<void> longPressDragWidget(Finder finder, Offset offset) async {
    await longPressDrag(getCenter(finder), offset);
  }

  /// Drags [tile] to [target] and holds it there long enough for an edge trigger to fire, without releasing.
  ///
  /// The drag stops halfway first, since a drag target does not register a single move past it as an enter.
  Future<TestGesture> holdDragAt(Finder tile, Offset target) async {
    final center = getCenter(tile);
    final gesture = await startGesture(center);
    await pump();
    await gesture.moveTo(Offset.lerp(center, target, 0.5)!);
    await pump();
    await gesture.moveTo(target);
    await pump();
    await pump(const Duration(milliseconds: 800));
    await pump(const Duration(milliseconds: 250));
    return gesture;
  }

  /// Creates a mouse [TestGesture] positioned at [Offset.zero] and registers
  /// [TestGesture.removePointer] as a teardown so callers don't have to.
  Future<TestGesture> createMouseGesture() async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    return gesture;
  }
}
