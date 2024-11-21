import 'dart:async';

import 'package:flutter/material.dart';

/// This widget uses a [DragTarget] to trigger navigation of the calendar.
class CursorNavigationTrigger extends StatefulWidget {
  /// The child.
  final Widget? child;

  /// Callback for when a trigger event happened.
  final void Function() onTrigger;

  /// The delay before the trigger triggers.
  final Duration triggerDelay;

  const CursorNavigationTrigger({
    super.key,
    this.child,
    required this.onTrigger,
    this.triggerDelay = const Duration(milliseconds: 500),
  });

  @override
  State<CursorNavigationTrigger> createState() => _CursorNavigationTriggerState();
}

class _CursorNavigationTriggerState extends State<CursorNavigationTrigger> {
  /// The timer used to trigger the navigation.
  Timer? triggerTimer;

  @override
  void dispose() {
    triggerTimer?.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    triggerTimer?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onWillAcceptWithDetails: (details) {
        // Start the timer on enter.
        triggerTimer = Timer.periodic(
          widget.triggerDelay,
          (timer) => widget.onTrigger(),
        );

        // Always return false to allow the drag to continue.
        return false;
      },
      onLeave: (data) {
        // Cancel the timer on leave.
        triggerTimer?.cancel();
      },
      builder: (context, candidateData, rejectedData) {
        return widget.child ?? const SizedBox();
      },
    );
  }
}
