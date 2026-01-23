import 'package:flutter/material.dart';
import 'package:kalender/src/models/providers/calendar_provider.dart';

/// The function that is called when the event is tapped.
typedef EventTileOnTapUp = void Function(TapUpDetails details, BuildContext context);

/// A gesture detector that wraps the event tile to handle taps.
class TileGestureDetector extends StatelessWidget {
  /// The function that is called when the event is tapped.
  final EventTileOnTapUp? onTapUp;

  /// The key used to identify the gesture detector.
  final Key gestureDetectorKey;

  /// The child widget.
  final Widget child;

  /// Creates a tile gesture detector.
  const TileGestureDetector({
    super.key,
    required this.onTapUp,
    required this.gestureDetectorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Check if gesture detection is enabled via callbacks.
    final callbacks = context.callbacks();
    final enableGestureDetection = callbacks?.onEventTapped != null || callbacks?.onEventTappedWithDetail != null;

    // If no onTapUp callback is provided or gesture detection is disabled, return the child as is.
    if (onTapUp == null || !enableGestureDetection) return child;

    // Wrap the child in a GestureDetector to handle tap events.
    return GestureDetector(onTapUp: (details) => onTapUp!(details, context), key: gestureDetectorKey, child: child);
  }
}
