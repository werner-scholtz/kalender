// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Tests for the off-screen tile culling in the day event column. Only events
// whose time band is within the visible scroll window (plus an overscan margin)
// are built.
//
// These use a real KalenderView so the vertical scroll view is attached and the
// culling actually runs. Without an attached scroll view the column falls back
// to building every event, and neither behaviour below could be observed.
void main() {
  final day = DateTime(2025, 3, 24);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
    kalenderController = KalenderController();
  });

  // Adds one event on [day], starting at [hour] for [durationHours]. The view
  // uses 1 pixel per minute and starts the day at 00:00, so the tile's top
  // pixel is hour * 60.
  String addEvent(int hour, {int durationHours = 1}) {
    return eventsController.addEvent(
      KalenderEvent(
        start: day.copyWith(hour: hour),
        end: day.copyWith(hour: hour + durationHours),
      ),
    );
  }

  Future<void> pumpSingleDay(WidgetTester tester, {EventLayoutStrategy? strategy}) {
    final components = TileComponents(tileBuilder: (context, event, tileRange) => Container(key: ValueKey(event.id)));
    return pumpAndSettleWithMaterialApp(
      tester,
      KalenderView(
        eventsController: eventsController,
        kalenderController: kalenderController,
        viewConfiguration: MultiDayViewConfiguration.singleDay(
          initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
          initialHeightPerMinute: 1,
          displayRange: KalenderDateTimeRange(start: day, end: day.add(const Duration(days: 1))),
          initialDateTime: day,
        ),
        body: KalenderBody(
          multiDayTileComponents: components,
          multiDayBodyConfiguration: strategy == null ? null : MultiDayBodyConfiguration(eventLayoutStrategy: strategy),
        ),
      ),
    );
  }

  ScrollPosition bodyScrollPosition() {
    final viewController = kalenderController.viewController as MultiDayViewController;
    return viewController.scrollController.position;
  }

  testWidgets('an event partially inside the viewport is still built', (tester) async {
    // Midday event (top at 720px) so there is room to scroll it under the edge.
    final id = addEvent(12, durationHours: 2);
    await pumpSingleDay(tester);

    final position = bodyScrollPosition();
    // Scroll so the event's top sits just above the viewport's bottom edge: the
    // top slice is visible and the rest hangs off the bottom. A partially
    // visible tile must still be built.
    position.jumpTo(720 - (position.viewportDimension - 20));
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('scrolling reveals a tile that was culled off-screen', (tester) async {
    // Late-evening event (top at 1320px), far below the initial window.
    final id = addEvent(22);
    await pumpSingleDay(tester);

    // At the top of the day it sits outside the window and overscan, so its
    // tile is not built.
    expect(find.byKey(ValueKey(id)), findsNothing);

    // Scroll to the bottom of the day. The event now enters the window and its
    // tile is built.
    final position = bodyScrollPosition();
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('culling uses the band from calculateVerticalLayoutData', (tester) async {
    // A late-evening event that the delegate below draws at the top of the day.
    final id = addEvent(22);
    await pumpSingleDay(tester, strategy: const _TopStrategy());

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('culling drops an event the delegate draws off screen', (tester) async {
    final id = addEvent(1);
    await pumpSingleDay(tester, strategy: const _BottomStrategy());

    expect(find.byKey(ValueKey(id)), findsNothing);
  });

  testWidgets('a configuration change recomputes the bands', (tester) async {
    final id = addEvent(22);
    await pumpSingleDay(tester);
    expect(find.byKey(ValueKey(id)), findsNothing);

    await pumpSingleDay(tester, strategy: const _TopStrategy());
    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('an event without layout data is not built', (tester) async {
    final id = addEvent(9);
    await pumpSingleDay(tester, strategy: const _SkipStrategy());

    expect(find.byKey(ValueKey(id)), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

/// A strategy whose delegate is [_Delegate] with the given [layout].
class _Strategy extends EventLayoutStrategy {
  const _Strategy(this.layout);

  final List<VerticalLayoutData> Function(int count) layout;

  @override
  EventLayoutDelegate createDelegate({
    required Iterable<KalenderEvent> events,
    required FloatingDateTime date,
    required KalenderTimeRange timeOfDayRange,
    required double heightPerMinute,
    required double? minimumTileHeight,
    required EventLayoutDelegateCache? cache,
    required Location? location,
  }) {
    return _Delegate(
      layout: layout,
      events: events,
      date: date,
      heightPerMinute: heightPerMinute,
      timeOfDayRange: timeOfDayRange,
      minimumTileHeight: minimumTileHeight,
      layoutCache: cache ?? EventLayoutDelegateCache(),
      location: location,
    );
  }
}

class _Delegate extends OverlapLayoutDelegate {
  _Delegate({
    required this.layout,
    required super.events,
    required super.heightPerMinute,
    required super.date,
    required super.location,
    required super.timeOfDayRange,
    required super.minimumTileHeight,
    required super.layoutCache,
  });

  final List<VerticalLayoutData> Function(int count) layout;

  @override
  List<VerticalLayoutData> calculateVerticalLayoutData(Size size) => layout(events.length);
}

/// Draws every event in the first hour of the day.
class _TopStrategy extends _Strategy {
  const _TopStrategy() : super(_layout);

  static List<VerticalLayoutData> _layout(int count) => [
    for (var i = 0; i < count; i++) VerticalLayoutData(id: i, top: 0, bottom: 60),
  ];
}

/// Draws every event in the last hour of the day.
class _BottomStrategy extends _Strategy {
  const _BottomStrategy() : super(_layout);

  static List<VerticalLayoutData> _layout(int count) => [
    for (var i = 0; i < count; i++) VerticalLayoutData(id: i, top: 1380, bottom: 1440),
  ];
}

/// Lays out no event.
class _SkipStrategy extends _Strategy {
  const _SkipStrategy() : super(_layout);

  static List<VerticalLayoutData> _layout(int count) => const [];
}
