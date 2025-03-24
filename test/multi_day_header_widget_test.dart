import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/src/widgets/internal_components/multi_day_header_layout.dart' show MultiDayHeaderWidget;

import 'utilities.dart';

void main() {
  group('MultiDayHeaderWidget Tests', () {
    // The layout checks to test the [MultiDayHeaderWidget].
    // `name : [contentHeight, leadingHeight, expectedHeight]`
    final layoutChecks = <String, List<double>>{
      'content & leading same height': [48.0, 48.0, 48.0],
      'content (height) is larger than leading': [96.0, 48.0, 96.0],
      'leading (height) is larger than content': [48.0, 96.0, 96.0],
    };

    for (final layoutChecks in layoutChecks.entries) {
      testWidgets('Test MultiDayHeaderWidget (${layoutChecks.key})', (tester) async {
        final contentHeight = layoutChecks.value[0];
        final leadingHeight = layoutChecks.value[1];
        final expectedHeight = layoutChecks.value[2];

        await tester.pumpWidget(
          wrapWithMaterialApp(
            MultiDayHeaderWidget(
              content: SizedBox(height: contentHeight, key: const ValueKey('content')),
              leadingWidget: SizedBox(width: 48, height: leadingHeight, key: const ValueKey('leading')),
              prototypeTimelineOverride: const SizedBox(width: 48),
            ),
          ),
        );

        await tester.pump();

        // Assert: Verify the widget renders as expected.
        final headerFinder = find.byType(MultiDayHeaderWidget);
        final contentFinder = find.byKey(const ValueKey('content'));
        final leadingFinder = find.byKey(const ValueKey('leading'));

        expect(headerFinder, findsOneWidget);
        expect(contentFinder, findsOneWidget);
        expect(leadingFinder, findsOneWidget);

        final headerSize = tester.getSize(headerFinder);

        expect(
          headerSize.height,
          expectedHeight,
          reason: 'Header height (${headerSize.height}) is not the same as the expected height ($expectedHeight).',
        );
      });
    }

    testWidgets('Test MultiDayHeader dynamic size', (tester) async {
      final contentHeightNotifier = ValueNotifier(48.0);

      await tester.pumpWidget(
        wrapWithMaterialApp(
          MultiDayHeaderWidget(
            content: ValueListenableBuilder(
              valueListenable: contentHeightNotifier,
              builder: (context, value, child) => SizedBox(height: value, key: const ValueKey('content')),
            ),
            leadingWidget: const SizedBox(width: 48, height: 48, key: ValueKey('leading')),
            prototypeTimelineOverride: const SizedBox(width: 48),
          ),
        ),
      );

      final heightsToTest = [48.0, 96.0, 144.0, 192.0, 240.0];
      for (final height in heightsToTest) {
        contentHeightNotifier.value = height;
        await tester.pumpAndSettle();

        final headerFinder = find.byType(MultiDayHeaderWidget);
        final contentFinder = find.byKey(const ValueKey('content'));
        final leadingFinder = find.byKey(const ValueKey('leading'));

        expect(headerFinder, findsOneWidget);
        expect(contentFinder, findsOneWidget);
        expect(leadingFinder, findsOneWidget);

        final headerSize = tester.getSize(headerFinder);

        expect(
          headerSize.height,
          height,
          reason: 'Header height (${headerSize.height}) is not the same as the expected height ($height).',
        );
      }
    });
  });
}
