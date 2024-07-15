import 'dart:async';

import 'package:flutter/material.dart';

class NavigationTrigger extends StatefulWidget {
  final Widget? child;
  final Function() onTrigger;
  final Duration triggerDelay;

  const NavigationTrigger({
    super.key,
    this.child,
    required this.onTrigger,
    this.triggerDelay = const Duration(milliseconds: 500),
  });

  @override
  State<NavigationTrigger> createState() => _NavigationTriggerState();
}

class _NavigationTriggerState extends State<NavigationTrigger> {
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
