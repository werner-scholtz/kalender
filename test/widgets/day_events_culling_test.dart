// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

// Off-screen tile culling in the day event column. A real KalenderView attaches the scroll view, without which the
// column builds every event.
void main() {
  final day = DateTime(2025, 3, 24);

  late DefaultEventsController eventsController;
  late KalenderController kalenderController;

  setUp(() {
    eventsController = DefaultEventsController();
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
    kalenderController = KalenderController(
      viewConfiguration: MultiDayViewConfiguration.singleDay(
        initialTimeOfDay: const KalenderTime(hour: 0, minute: 0),
        initialHeightPerMinute: 1,
        displayRange: KalenderDateTimeRange(start: day, end: day.add(const Duration(days: 1))),
        initialDateTime: day,
      ),
    );
    return pumpKalender(
      tester,
      eventsController: eventsController,
      kalenderController: kalenderController,
      body: KalenderBody(
        multiDayTileComponents: components,
        multiDayBodyConfiguration: strategy == null ? null : MultiDayBodyConfiguration(eventLayoutStrategy: strategy),
      ),
    );
  }

  ScrollPosition bodyScrollPosition() {
    final viewController = kalenderController.viewController as MultiDayViewController;
    return viewController.scrollController.position;
  }

  testWidgets('an event partially inside the viewport is still built', (tester) async {
    // Top at 720px.
    final id = addEvent(12, durationHours: 2);
    await pumpSingleDay(tester);

    final position = bodyScrollPosition();
    // The event's top sits 20px above the viewport's bottom edge.
    position.jumpTo(720 - (position.viewportDimension - 20));
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('scrolling reveals a tile that was culled off-screen', (tester) async {
    // Top at 1320px.
    final id = addEvent(22);
    await pumpSingleDay(tester);

    expect(find.byKey(ValueKey(id)), findsNothing);

    final position = bodyScrollPosition();
    position.jumpTo(position.maxScrollExtent);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey(id)), findsOneWidget);
  });

  testWidgets('culling uses the band from calculateVerticalLayoutData', (tester) async {
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
