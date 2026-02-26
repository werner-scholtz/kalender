import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart' show MultiDayHeaderWidget;

import 'utilities.dart';

// Finders are constant across all MultiDayHeaderWidget tests.
final _headerFinder = find.byType(MultiDayHeaderWidget);
final _contentFinder = find.byKey(const ValueKey('content'));
final _leadingFinder = find.byKey(const ValueKey('leading'));

/// Asserts that the header, content, and leading widgets are all present and
/// that the header has the given [expectedHeight].
void _expectHeader(WidgetTester tester, double expectedHeight) {
  expect(_headerFinder, findsOneWidget);
  expect(_contentFinder, findsOneWidget);
  expect(_leadingFinder, findsOneWidget);
  final headerHeight = tester.getSize(_headerFinder).height;
  expect(
    headerHeight,
    expectedHeight,
    reason: 'Header height ($headerHeight) is not the same as the expected height ($expectedHeight).',
  );
}

void main() {
  group('MultiDayHeaderWidget Tests', () {
    // Layout cases: (description, contentHeight, leadingHeight, expectedHeight).
    final layoutChecks = <({String name, double contentHeight, double leadingHeight, double expectedHeight})>[
      (name: 'content & leading same height', contentHeight: 48.0, leadingHeight: 48.0, expectedHeight: 48.0),
      (name: 'content height larger than leading', contentHeight: 96.0, leadingHeight: 48.0, expectedHeight: 96.0),
      (name: 'leading height larger than content', contentHeight: 48.0, leadingHeight: 96.0, expectedHeight: 96.0),
    ];

    for (final check in layoutChecks) {
      testWidgets('layout - ${check.name}', (tester) async {
        await pumpAndSettleWithMaterialApp(
          tester,
          MultiDayHeaderWidget(
            content: SizedBox(height: check.contentHeight, key: const ValueKey('content')),
            leading: SizedBox(width: 48, height: check.leadingHeight, key: const ValueKey('leading')),
            prototypeTimelineOverride: const SizedBox(width: 48),
          ),
        );

        _expectHeader(tester, check.expectedHeight);
      });
    }

    testWidgets('resizes dynamically when content height changes', (tester) async {
      final contentHeightNotifier = ValueNotifier(48.0);

      await pumpAndSettleWithMaterialApp(
        tester,
        MultiDayHeaderWidget(
          content: ValueListenableBuilder(
            valueListenable: contentHeightNotifier,
            builder: (context, value, child) => SizedBox(height: value, key: const ValueKey('content')),
          ),
          leading: const SizedBox(width: 48, height: 48, key: ValueKey('leading')),
          prototypeTimelineOverride: const SizedBox(width: 48),
        ),
      );

      for (final height in [48.0, 96.0, 144.0, 192.0, 240.0]) {
        contentHeightNotifier.value = height;
        await tester.pumpAndSettle();
        _expectHeader(tester, height);
      }
    });
  });
}
