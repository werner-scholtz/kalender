import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The function that is called when the event is tapped.
typedef EventTileOnTapUp = void Function(TapUpDetails details, BuildContext context);

/// A gesture detector that wraps the event tile to handle taps.
class TileGestureDetector extends StatelessWidget {
  /// The function that is called when the event is tapped.
  final EventTileOnTapUp? onTapUp;

  /// The function that is called when the event is secondary tapped.
  final EventTileOnTapUp? onSecondaryTapUp;

  /// The key used to identify the gesture detector.
  final Key gestureDetectorKey;

  /// The child widget.
  final Widget child;

  /// Creates a tile gesture detector.
  const TileGestureDetector({
    super.key,
    required this.onTapUp,
    required this.onSecondaryTapUp,
    required this.gestureDetectorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Check if gesture detection is enabled via callbacks.
    final callbacks = context.callbacks;
    final enableGestureDetection = callbacks?.onEventTapped != null || callbacks?.onEventTappedWithDetail != null;
    final enableSecondaryGestureDetection =
        callbacks?.onEventSecondaryTapped != null || callbacks?.onEventSecondaryTappedWithDetail != null;

    // If no callbacks are provided or gesture detection is disabled, return the child as is.
    if ((onTapUp == null || !enableGestureDetection) &&
        (onSecondaryTapUp == null || !enableSecondaryGestureDetection)) {
      return child;
    }

    // Wrap the child in a GestureDetector to handle tap events.
    return GestureDetector(
      onTapUp: enableGestureDetection && onTapUp != null ? (details) => onTapUp!(details, context) : null,
      onSecondaryTapUp: enableSecondaryGestureDetection && onSecondaryTapUp != null
          ? (details) => onSecondaryTapUp!(details, context)
          : null,
      key: gestureDetectorKey,
      child: child,
    );
  }
}
