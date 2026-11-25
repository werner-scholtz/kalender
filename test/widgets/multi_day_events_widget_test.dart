// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/widgets/event_tiles/tiles/multi_day_tile.dart';
import 'package:kalender/src/widgets/events_widgets/multi_day_events_widget.dart';
import 'package:material_ui/material_ui.dart';

import '../utilities.dart';

/// A [MultiDayEventWidget] updated before its first frame ends shows the events of its new inputs.
void main() {
  final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2026));
  final week = MultiDayViewConfiguration.week(displayRange: range, initialDateTime: DateTime(2025, 6, 4));

  FloatingDateTimeRange days(int start, int end) =>
      FloatingDateTimeRange(start: FloatingDateTime(2025, 6, start), end: FloatingDateTime(2025, 6, end));

  DefaultEventsController eventsOn(List<int> days) {
    final controller = DefaultEventsController();
    for (final day in days) {
      controller.addEvent(KalenderEvent(start: DateTime.utc(2025, 6, day), end: DateTime.utc(2025, 6, day + 1)));
    }
    return controller;
  }

  List<int> shownDays(WidgetTester tester) =>
      tester.widgetList<MultiDayEventTile>(find.byType(MultiDayEventTile)).map((tile) => tile.event.start.day).toList()
        ..sort();

  final first = eventsOn([2, 3, 10, 11, 12]);
  final second = eventsOn([4]);
  for (final (name, eventsController, floatingRange, expected) in [
    ('range', first, days(9, 16), [10, 11, 12]),
    ('eventsController', second, days(2, 9), [4]),
  ]) {
    testWidgets('a new $name before the first frame ends', (tester) async {
      final kalenderController = KalenderController(viewConfiguration: week);
      Widget eventsWidget(EventsController eventsController, FloatingDateTimeRange floatingRange) =>
          MultiDayEventWidget(
            eventsController: eventsController,
            configuration: const MultiDayHeaderConfiguration(),
            floatingRange: floatingRange,
            availableRows: null,
            viewController: kalenderController.viewController,
            overlayBuilders: null,
          );
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: TestProvider(
              kalenderController: kalenderController,
              eventsController: first,
              tileComponents: TileComponents.defaultComponents(),
              child: _LayoutTwice(
                child: LayoutBuilder(
                  builder: (context, constraints) => constraints.maxWidth == 400
                      ? eventsWidget(first, days(2, 9))
                      : eventsWidget(eventsController, floatingRange),
                ),
              ),
            ),
          ),
        ),
      );
      final firstFrame = shownDays(tester);
      await tester.pump();

      expect([firstFrame, shownDays(tester)], [expected, expected]);
    });
  }
}

/// Lays its child out at two widths, so a [LayoutBuilder] child builds twice in one frame.
class _LayoutTwice extends SingleChildRenderObjectWidget {
  const _LayoutTwice({super.child});

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderLayoutTwice();
}

class _RenderLayoutTwice extends RenderProxyBox {
  @override
  void performLayout() {
    child!.layout(BoxConstraints.tight(const Size(400, 300)));
    child!.layout(BoxConstraints.tight(const Size(401, 300)), parentUsesSize: true);
    size = constraints.constrain(child!.size);
  }
}
