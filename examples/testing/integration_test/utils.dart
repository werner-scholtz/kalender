// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';
import 'package:testing/tiles.dart';

import '../test_driver/perf_driver.dart';

/// The tile widget the app builds for events in [view].
Type tileTypeOf(Views view) => view == Views.week ? EventTile : MultiDayEventTile;

/// The rects of every tile of [type], in tree order, which is also paint order.
List<Rect> tileRects(WidgetTester tester, Type type) {
  final tiles = find.byType(type);
  final count = tiles.evaluate().length;
  return [for (var i = 0; i < count; i++) tester.getRect(tiles.at(i))];
}

/// The body of the active view.
final Finder calendarBody = find.byWidgetPredicate(
  (widget) => widget is MultiDayBody || widget is MonthBody || widget is ScheduleBody,
);

/// The part of the [calendarBody] a press reaches a tile in.
///
/// A tile drawn past the edge of the window cannot be pressed, and the paged views turn the page while the pointer
/// is over their left and right edges.
Rect pressableArea(WidgetTester tester, Views view) {
  final body = tester.getRect(calendarBody);
  if (view == Views.schedule) return body;
  final margin = body.width / 10;
  return Rect.fromLTRB(body.left + margin, body.top, body.right - margin, body.bottom);
}

bool _inside(Rect area, Rect rect) => area.contains(rect.topLeft) && area.contains(rect.bottomRight);

/// The first tile inside [area], in tree order.
Rect firstTileInside(List<Rect> tiles, Rect area) {
  return tiles.firstWhere((rect) => _inside(area, rect), orElse: () => throw StateError('No tile lies inside $area.'));
}

/// The end handle of the latest-ending tile inside [area] that leaves [room] below it and that nothing covers.
///
/// A later tile containing the point is painted over it, and hides the handle unless the point lies within
/// [handleLength] of that tile's own bottom, where its end handle takes the press instead.
Offset endHandleInside(List<Rect> tiles, Rect area, {required double room, double handleLength = 16}) {
  Offset? handle;
  var bottom = double.negativeInfinity;
  for (var i = 0; i < tiles.length; i++) {
    final rect = tiles[i];
    if (!_inside(area, rect) || rect.bottom + room > area.bottom || rect.bottom <= bottom) continue;
    final point = Offset(rect.center.dx, rect.bottom - 2);
    final covered = tiles.skip(i + 1).any((later) => later.contains(point) && later.bottom - point.dy > handleLength);
    if (covered) continue;
    handle = point;
    bottom = rect.bottom;
  }
  return handle ?? (throw StateError('No tile inside $area has a reachable end handle with $room below it.'));
}

/// The right edge of the first tile inside [area] that leaves [room] to its right.
Offset rightEdgeInside(List<Rect> tiles, Rect area, {required double room}) {
  final rect = tiles.firstWhere(
    (rect) => _inside(area, rect) && rect.right + room <= area.right,
    orElse: () => throw StateError('No tile inside $area has $room to its right.'),
  );
  return Offset(rect.right - 2, rect.center.dy);
}

/// Records whether [controller] reported an event under a drag, which every processed drag move sets.
class DragProbe {
  DragProbe(this.controller) {
    controller.selectedEvent.addListener(_onSelectedEvent);
  }

  final KalenderController controller;

  /// Whether a drag moved at least once since this probe was created.
  var dragged = false;

  void _onSelectedEvent() {
    if (controller.selectedEvent.value != null) dragged = true;
  }

  void dispose() => controller.selectedEvent.removeListener(_onSelectedEvent);
}

/// The start and end of every event in [controller], by id.
Map<String, (DateTime, DateTime)> snapshotEvents(DefaultEventsController controller) {
  return {for (final event in controller.events) event.id: (event.start, event.end)};
}

/// The ids of the events whose start or end differs from [before].
List<String> changedEvents(DefaultEventsController controller, Map<String, (DateTime, DateTime)> before) {
  final changed = <String>[];
  for (final entry in before.entries) {
    final event = controller.byId(entry.key);
    if (event != null && (event.start, event.end) != entry.value) changed.add(entry.key);
  }
  return changed;
}

/// Moves [dragGesture] from [start] to [end] in [segmentCount] steps, pumping a frame after each.
Future<void> performSegmentedDrag(
  TestGesture dragGesture,
  WidgetTester tester,
  Offset start,
  Offset end, {
  int segmentCount = 10,
  int segmentDurationMs = 50,
  int pumpDurationMs = 20,
}) async {
  for (int i = 1; i <= segmentCount; i++) {
    final t = i / segmentCount;
    final intermediate = Offset.lerp(start, end, t)!;
    await dragGesture.moveTo(intermediate, timeStamp: Duration(milliseconds: segmentDurationMs * i));
    await tester.pump(Duration(milliseconds: pumpDurationMs));
  }
}

extension ViewUtils on Views {
  ViewConfiguration get viewConfiguration {
    switch (this) {
      case Views.week:
        return MultiDayViewConfiguration.week(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
      case Views.month:
        return MonthViewConfiguration.singleMonth(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
      case Views.schedule:
        return ScheduleViewConfiguration.continuous(
          displayRange: TestConfiguration.testRange,
          initialDateTime: TestConfiguration.initialDateTime,
        );
    }
  }
}

extension ScenarioUtils on Scenario {
  List<KalenderTimeRange> get eventRanges => timeOfDayRanges.take(numberOfEvents).toList();
}
