import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

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

  /// A page-navigation trigger that advances the view by one page while a drag
  /// hovers it.
  ///
  /// [forward] picks the direction: `true` goes to the next page, `false` to the
  /// previous one. Both use the delay, duration, and curve from [configuration].
  /// When no [builder] is given it falls back to an edge strip [pageWidth] / 50
  /// wide. The trigger is meant to sit inside a [Positioned] that pins its top
  /// and bottom, so the fallback only sets a width.
  factory CursorNavigationTrigger.page({
    Key? key,
    required PageTriggerConfiguration configuration,
    required ViewController viewController,
    required bool forward,
    required double pageWidth,
    HorizontalTriggerWidgetBuilder? builder,
  }) {
    return CursorNavigationTrigger(
      key: key,
      triggerDelay: configuration.triggerDelay,
      onTrigger: () => forward
          ? viewController.animateToNextPage(
              duration: configuration.animationDuration,
              curve: configuration.animationCurve,
            )
          : viewController.animateToPreviousPage(
              duration: configuration.animationDuration,
              curve: configuration.animationCurve,
            ),
      child: builder?.call(pageWidth) ?? ConstrainedBox(constraints: BoxConstraints.expand(width: pageWidth / 50)),
    );
  }

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
