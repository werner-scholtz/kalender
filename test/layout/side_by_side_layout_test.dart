// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

import '../utilities.dart';

/// How [SideBySideLayoutDelegate] places tiles in columns (#623).
void main() {
  /// Layout data with one pixel per minute, from `(start hour, start minute, end hour, end minute)`.
  List<VerticalLayoutData> tiles(List<(int, int, int, int)> spans) => [
    for (final (i, (sh, sm, eh, em)) in spans.indexed)
      VerticalLayoutData(id: i, top: sh * 60.0 + sm, bottom: eh * 60.0 + em),
  ];

  Map<int, (int, int, int)> placed(List<VerticalLayoutData> data) => {
    for (final p in SideBySideLayoutDelegate.arrange(data)) p.id: (p.column, p.span, p.columns),
  };

  final cases = [
    (
      name: 'at most five events at once use five columns',
      spans: [
        (11, 0, 11, 30),
        (11, 0, 11, 30),
        (11, 0, 11, 30),
        (11, 0, 11, 15),
        (11, 15, 12, 0),
        (11, 15, 11, 45),
        (11, 30, 12, 0),
        (11, 30, 11, 45),
      ],
      expected: {
        0: (0, 1, 5),
        1: (1, 1, 5),
        2: (2, 1, 5),
        3: (3, 2, 5),
        4: (3, 1, 5),
        5: (4, 1, 5),
        6: (0, 1, 5),
        7: (1, 2, 5),
      },
    ),
    (
      name: 'tiles that overlap one after another share two columns',
      spans: [(9, 0, 10, 0), (9, 45, 10, 30), (10, 15, 11, 15), (10, 45, 11, 45)],
      expected: {0: (0, 1, 2), 1: (1, 1, 2), 2: (0, 1, 2), 3: (1, 1, 2)},
    ),
    (
      name: 'tiles that only touch keep the full width',
      spans: [(9, 0, 10, 0), (10, 0, 11, 0)],
      expected: {0: (0, 1, 1), 1: (0, 1, 1)},
    ),
    (
      name: 'a tile widens over the columns free for its whole height',
      spans: [(9, 0, 10, 0), (9, 0, 9, 30), (9, 0, 9, 30), (9, 30, 10, 0)],
      expected: {0: (0, 1, 3), 1: (1, 1, 3), 2: (2, 1, 3), 3: (1, 2, 3)},
    ),
  ];

  group('arrange', () {
    for (final (:name, :spans, :expected) in cases) {
      test(name, () => expect(placed(tiles(spans)), expected));
    }

    test('overlapping tiles never share horizontal space, and no group has more columns than events at once', () {
      final random = Random(623);
      for (var day = 0; day < 300; day++) {
        final data = tiles([
          for (var i = 0; i < 3 + random.nextInt(10); i++)
            () {
              final start = 9 * 60 + random.nextInt(12) * 15;
              final end = start + 15 * (1 + random.nextInt(6));
              return (start ~/ 60, start % 60, end ~/ 60, end % 60);
            }(),
        ]);
        final placements = {for (final p in SideBySideLayoutDelegate.arrange(data)) p.id: p};
        var mostAtOnce = 0;
        for (final tile in data) {
          mostAtOnce = max(mostAtOnce, data.where((other) => other.top <= tile.top && other.bottom > tile.top).length);
        }

        for (final a in data) {
          final pa = placements[a.id]!;
          expect(pa.column + pa.span, lessThanOrEqualTo(pa.columns), reason: 'day $day tile ${a.id}');
          for (final b in data.where((b) => b.id > a.id && b.overlaps(a))) {
            final pb = placements[b.id]!;
            final apart = pa.column + pa.span <= pb.column || pb.column + pb.span <= pa.column;
            expect(apart, isTrue, reason: 'day $day tiles ${a.id} and ${b.id}');
          }
        }
        expect(placements.values.map((p) => p.columns).reduce(max), mostAtOnce, reason: 'day $day');
      }
    });
  });

  group('SideBySideLayoutDelegate', () {
    final day = DateTime(2025, 1, 6);
    const width = 400.0;

    Future<List<Rect>> layout(
      WidgetTester tester,
      List<(int, int, int, int)> spans, {
      required double heightPerMinute,
      double? minimumTileHeight,
    }) async {
      final events = [
        for (final (sh, sm, eh, em) in spans)
          KalenderEvent(
            start: day.copyWith(hour: sh, minute: sm),
            end: day.copyWith(hour: eh, minute: em),
          ),
      ];
      await tester.pumpWidget(
        wrapWithMaterialApp(
          SingleChildScrollView(
            child: SizedBox(
              width: width,
              height: 24 * 60 * heightPerMinute,
              child: CustomMultiChildLayout(
                key: const ValueKey('layout'),
                delegate: const EventLayoutStrategy.sideBySide().createDelegate(
                  events: events,
                  date: FloatingDateTime.fromDateTime(day),
                  timeOfDayRange: KalenderTimeRange.allDay(),
                  heightPerMinute: heightPerMinute,
                  minimumTileHeight: minimumTileHeight,
                  cache: null,
                  location: null,
                ),
                children: [
                  for (var i = 0; i < events.length; i++)
                    LayoutId(
                      id: i,
                      child: SizedBox(key: ValueKey(i)),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      final left = tester.getTopLeft(find.byKey(const ValueKey('layout'))).dx;
      return [for (var i = 0; i < events.length; i++) tester.getRect(find.byKey(ValueKey(i))).translate(-left, 0)];
    }

    for (final (minimumTileHeight, expectedWidth) in [(null, width), (24.0, width / 2)]) {
      testWidgets('with minimumTileHeight $minimumTileHeight, a stretched tile counts as long as it is drawn', (
        tester,
      ) async {
        final rects = await layout(
          tester,
          [(11, 0, 11, 15), (11, 15, 11, 30)],
          heightPerMinute: 1,
          minimumTileHeight: minimumTileHeight,
        );
        expect(rects.map((rect) => rect.width), everyElement(expectedWidth));
      });
    }

    testWidgets('stretched tiles at a low zoom stay inside the column', (tester) async {
      final rects = await layout(
        tester,
        [
          (10, 15, 11, 15),
          (9, 30, 10, 45),
          (10, 15, 11, 15),
          (10, 0, 10, 30),
          (9, 0, 10, 15),
          (9, 15, 9, 45),
          (10, 15, 10, 30),
          (9, 15, 9, 30),
        ],
        heightPerMinute: 0.5,
        minimumTileHeight: 24,
      );
      expect(rects.every((rect) => rect.width > 0 && rect.left >= 0 && rect.right <= width + 0.01), isTrue);
    });
  });
}
