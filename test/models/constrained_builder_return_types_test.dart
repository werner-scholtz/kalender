import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kalender/kalender.dart';

/// Two builder typedefs return a package class rather than a [Widget], so the
/// class has to be exported or the typedef cannot be implemented.
///
/// This has shipped broken twice: `PageIndexCalculator` before 0.26.0 and
/// `MultiDayEventOverlayTile` before 0.27.0. These are compile-time checks, so
/// a regression fails the analyzer rather than the expectation below.
void main() {
  test('MultiDayOverlayEventTileBuilder can be implemented', () {
    MultiDayEventOverlayTile build(
      BuildContext context,
      KalenderEvent event,
      InternalDateTimeRange internalRange,
      VoidCallback dismissOverlay,
    ) {
      return MultiDayEventOverlayTile(
        event: event,
        tileComponents: TileComponents(tileBuilder: (context, event, range) => const SizedBox()),
        dateTimeRange: internalRange,
        resizeAxis: null,
        dismissOverlay: dismissOverlay,
      );
    }

    // Typed as the builder, so `build` is checked against the typedef.
    void accept(MultiDayOverlayEventTileBuilder builder) => expect(builder, isNotNull);

    accept(build);
  });

  test('ResizeHandleDetails builds a nameable ResizeDetector', () {
    final range = KalenderDateTimeRange(start: DateTime(2025), end: DateTime(2025, 1, 2));
    final details = ResizeHandleDetails(
      event: KalenderEvent(start: range.start, end: range.end),
      interaction: KalenderInteraction(),
      dateTimeRange: InternalDateTimeRange.fromDateTimeRange(range),
      size: const Size(100, 100),
      axis: Axis.vertical,
      isImprecise: false,
    );

    // Typed as ResizeDetector, so the detectors are checked against the export.
    ResizeDirection directionOf(ResizeDetector handle) => handle.direction;

    expect(directionOf(details.startResizeDetector), ResizeDirection.top);
    expect(directionOf(details.endResizeDetector), ResizeDirection.bottom);
  });
}
