import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

class ZoomDetector extends StatelessWidget {
  final Widget child;
  final CalendarController controller;
  const ZoomDetector({super.key, required this.child, required this.controller});

  @override
  Widget build(BuildContext context) {
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.android => MobileZoomDetector(controller: controller, child: child),
      _ => DesktopZoomDetector(controller: controller, child: child),
    };
  }
}

mixin ZoomUtils {
  CalendarController get controller;
  ViewController? get viewController => controller.viewController;

  /// The minimum zoom level for the calendar.
  final minimumZoomLevel = 0.5;

  /// The maximum zoom level for the calendar.
  final maximumZoomLevel = 2.0;

  /// The scroll sensitivity for the calendar.
  final scrollSensitivity = 0.1;

  /// The [MultiDayViewController] of the calendar.
  ///
  /// Returns null if the [viewController] is not a [MultiDayViewController].
  MultiDayViewController? get multiDayViewController {
    if (viewController is MultiDayViewController) {
      return viewController as MultiDayViewController;
    } else {
      return null;
    }
  }

  /// The [ScrollController] of the calendar.
  ScrollController? get scrollController => multiDayViewController?.scrollController;

  /// The [ValueNotifier] that holds the height per minute of the calendar.
  ValueNotifier<double>? get heightPerMinute => multiDayViewController?.heightPerMinute;

  /// The [ValueNotifier] that holds the state of the control key.
  ValueNotifier<bool> lock = ValueNotifier(false);

  /// 
  double yOffset = 0;

  double scaleTrackpad(PointerPanZoomUpdateEvent event, double height) {
    return height * pow(2, log(event.scale) / 12);
  }

  double scale(PointerScaleEvent event, double height) {
    final newHeight = height * pow(2, log(event.scale) / 4);
    return newHeight.clamp(minimumZoomLevel, maximumZoomLevel);
  }

  double scroll(PointerScrollEvent event, double height) {
    return height + event.scrollDelta.dy.sign * -1 * scrollSensitivity;
  }

  /// Updates the height of the calendar and scrolls to the new position.
  void update(double height, double newHeight) {
    final clamped = newHeight.clamp(minimumZoomLevel, maximumZoomLevel);

    final zoomRatio = clamped / height;
    final scrollPosition = scrollController?.position.pixels;
    if (scrollPosition == null) return;

    final pointerPosition = scrollPosition + yOffset;
    final newPosition = (pointerPosition * zoomRatio) - yOffset;
    scrollController?.jumpTo(newPosition);
    heightPerMinute?.value = clamped;
  }

  bool keyHandler(KeyEvent event) {
    lock.value = HardwareKeyboard.instance.isControlPressed;
    return false;
  }

  ScrollBehavior scrollBehavior(bool lock) {
    return (lock ? const ScrollBehaviorNever() : const MaterialScrollBehavior()).copyWith(scrollbars: false);
  }
}

class DesktopZoomDetector extends StatefulWidget {
  final Widget child;
  final CalendarController controller;
  const DesktopZoomDetector({super.key, required this.child, required this.controller});

  @override
  State<DesktopZoomDetector> createState() => _DesktopZoomDetectorState();
}

class _DesktopZoomDetectorState extends State<DesktopZoomDetector> with ZoomUtils {
  @override
  CalendarController<Object?> get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(keyHandler);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(keyHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (event) => yOffset = event.localPosition.dy,
      onPointerSignal: (event) {
        if (!HardwareKeyboard.instance.isControlPressed) return;

        final height = heightPerMinute?.value;
        if (height == null) return;

        double newHeight;
        if (event is PointerScaleEvent) {
          newHeight = scale(event, height);
        } else if (event is PointerScrollEvent) {
          newHeight = scroll(event, height);
        } else {
          return;
        }

        update(height, newHeight);
      },
      onPointerPanZoomStart: (_) => lock.value = true,
      onPointerPanZoomUpdate: (event) {
        if (lock.value == false) return;
        final height = heightPerMinute?.value;
        if (height == null) return;
        final newHeight = scaleTrackpad(event, height);
        update(height, newHeight);
      },
      behavior: HitTestBehavior.translucent,
      onPointerPanZoomEnd: (_) => lock.value = false,
      child: ValueListenableBuilder(
        valueListenable: lock,
        builder: (context, value, _) => ScrollConfiguration(behavior: scrollBehavior(value), child: widget.child),
      ),
    );
  }
}

class MobileZoomDetector extends StatefulWidget {
  final Widget child;
  final CalendarController controller;
  const MobileZoomDetector({super.key, required this.child, required this.controller});

  @override
  State<MobileZoomDetector> createState() => _MobileZoomDetectorState();
}

class _MobileZoomDetectorState extends State<MobileZoomDetector> with ZoomUtils {
  @override
  CalendarController<Object?> get controller => widget.controller;

  double _previousScale = 0.0;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowMultipleGestureRecognizer>(
          AllowMultipleGestureRecognizer.new,
          (instance) {
            instance.onStart = (details) {
              yOffset = details.localFocalPoint.dy;
              _previousScale = 0;
              if (details.pointerCount <= 1) return;
              // lock.value = true;
            };
            // instance.onEnd = (_) => lock.value = false;
            instance.onUpdate = (details) {
              if (details.pointerCount <= 1) return;
              final height = heightPerMinute?.value;
              if (height == null) return;
              final delta = -(_previousScale - log(details.verticalScale));
              _previousScale = log(details.verticalScale);
              final newHeight = height + delta;
              update(height, newHeight);
            };
          },
        ),
      },
      child: widget.child,
      // child: ValueListenableBuilder(
      //   valueListenable: lock,
      //   builder: (context, value, _) => ScrollConfiguration(
      //     behavior: value ? const ScrollBehaviorNever() : const MaterialScrollBehavior(),
      //     child: widget.child,
      //   ),
      // ),
    );
  }
}

class ScrollBehaviorNever extends ScrollBehavior {
  const ScrollBehaviorNever();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const NeverScrollableScrollPhysics();
}

class ZoomIntent extends Intent {
  const ZoomIntent();
}

class AllowMultipleGestureRecognizer extends ScaleGestureRecognizer {
  /// Allow this gesture recognizer to always win the gesture arena, this might result in two recognizers winning.
  @override
  void rejectGesture(int pointer) => acceptGesture(pointer);
}
