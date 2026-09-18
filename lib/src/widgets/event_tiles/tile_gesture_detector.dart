// This file is part of kalender.
//
// SPDX-FileCopyrightText: 2023 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
//
// SPDX-License-Identifier: MIT

import 'package:flutter/widgets.dart';
import 'package:kalender/src/models/providers/kalender_provider.dart';
import 'package:kalender/src/widgets/event_tiles/event_tile.dart';

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

  const TileGestureDetector({
    super.key,
    required this.onTapUp,
    required this.onSecondaryTapUp,
    required this.gestureDetectorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final callbacks = context.callbacks;
    final enableGestureDetection = callbacks?.hasOnEventTapped ?? false;
    final enableSecondaryGestureDetection = callbacks?.hasOnEventSecondaryTapped ?? false;

    if ((onTapUp == null || !enableGestureDetection) &&
        (onSecondaryTapUp == null || !enableSecondaryGestureDetection)) {
      return child;
    }

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
