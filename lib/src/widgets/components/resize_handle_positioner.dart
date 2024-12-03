import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kalender/src/platform.dart';

/// The base class for the ResizeDetectorPositioner.
abstract class ResizeHandlePositionerWidget extends StatelessWidget {
  /// The top/left resize detector.
  final Widget startResizeDetector;

  /// The bottom/right resize detector.
  final Widget endResizeDetector;

  /// Should the start resize detector be show.
  final bool showStart;

  /// Should the end resize detector be show.
  final bool showEnd;

  const ResizeHandlePositionerWidget({
    required this.startResizeDetector,
    required this.endResizeDetector,
    required this.showStart,
    required this.showEnd,
    super.key,
  });
}

/// A widget that positions the resize handles for a day event tile.
class VerticalTileResizeHandlePositioner extends ResizeHandlePositionerWidget {
  const VerticalTileResizeHandlePositioner({
    super.key,
    required super.startResizeDetector,
    required super.endResizeDetector,
    required super.showStart,
    required super.showEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        late final showTop = constraints.maxHeight > (isMobileDevice ? kMinInteractiveDimension : 24);
        const resizeHeight = 12.0;

        return Stack(
          children: [
            if (showTop && showStart)
              Positioned(
                top: 0,
                left: 0,
                right: isMobileDevice ? null : 0,
                width: isMobileDevice ? resizeHeight : null,
                height: resizeHeight,
                child: startResizeDetector,
              ),
            if (showEnd)
              Positioned(
                bottom: 0,
                left: isMobileDevice ? null : 0,
                right: 0,
                width: isMobileDevice ? resizeHeight : null,
                height: resizeHeight,
                child: endResizeDetector,
              ),
          ],
        );
      },
    );
  }
}

/// A widget that positions the resize handles for a day event tile.
class HorizontalTileResizeHandlePositioner extends ResizeHandlePositionerWidget {
  const HorizontalTileResizeHandlePositioner({
    super.key,
    required super.startResizeDetector,
    required super.endResizeDetector,
    required super.showStart,
    required super.showEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        late final resizeWidth = min(constraints.maxWidth * 0.25, 24.0);

        return Stack(
          children: [
            if (showStart && !isMobileDevice)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                width: resizeWidth,
                child: startResizeDetector,
              ),
            if (showEnd && !isMobileDevice)
              Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                width: resizeWidth,
                child: endResizeDetector,
              ),
          ],
        );
      },
    );
  }
}
