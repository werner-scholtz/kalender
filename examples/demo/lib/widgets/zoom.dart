import 'dart:math';

import 'package:demo/data/event.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

class CalendarZoomDetector extends StatefulWidget {
  final Widget child;
  final CalendarController<Event> controller;
  const CalendarZoomDetector({super.key, required this.child, required this.controller});

  @override
  State<CalendarZoomDetector> createState() => _CalendarZoomDetectorState();
}

class ScrollBehaviorNever extends ScrollBehavior {
  const ScrollBehaviorNever();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const NeverScrollableScrollPhysics();
}

class AllowMultipleGestureRecognizer extends ScaleGestureRecognizer {
  /// Allow this gesture recognizer to always win the gesture arena, this might result in two recognizers winning.
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}

class _CalendarZoomDetectorState extends State<CalendarZoomDetector> {
  final _min = 0.5;
  final _max = 2.0;
  final _scrollSensitivity = 0.1;

  MultiDayViewController<Event>? get viewController {
    final viewController = widget.controller.viewController;
    if (viewController is MultiDayViewController<Event>) {
      return viewController;
    } else {
      return null;
    }
  }

  ScrollController? get scrollController => viewController?.scrollController;
  ValueNotifier<double>? get heightPerMinute => viewController?.heightPerMinute;
  ValueNotifier<bool> lock = ValueNotifier(false);
  double _yOffset = 0;
  double _previousScale = 0;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(handler);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(handler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<AllowMultipleGestureRecognizer>(
          AllowMultipleGestureRecognizer.new,
          (instance) {
            instance.onStart = (details) {
              _yOffset = details.localFocalPoint.dy;
              _previousScale = 0;
              if (details.pointerCount <= 1) return;
              lock.value = true;
            };
            instance.onEnd = (_) => lock.value = false;
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
      child: Listener(
        onPointerHover: (event) => _yOffset = event.localPosition.dy,
        onPointerSignal: (event) {
          // Check that control is pressed
          if (!HardwareKeyboard.instance.isControlPressed) return;

          final height = heightPerMinute?.value;
          if (height == null) return;

          double newHeight;

          if (event is PointerScaleEvent) {
            // Handle web.
            newHeight = scale(event, height);
          } else if (event is PointerScrollEvent) {
            // Handle desktop.
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
        onPointerPanZoomEnd: (_) => lock.value = false,
        behavior: HitTestBehavior.translucent,
        child: ValueListenableBuilder(
          valueListenable: lock,
          builder: (context, value, _) => ScrollConfiguration(
            behavior: value ? const ScrollBehaviorNever() : const MaterialScrollBehavior(),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  bool handler(KeyEvent event) {
    lock.value = HardwareKeyboard.instance.isControlPressed;
    return false;
  }

  double scaleTrackpad(PointerPanZoomUpdateEvent event, double height) {
    return height * pow(2, log(event.scale) / 12);
  }

  double scaleMobile() {
    return 0.0;
  }

  double scale(PointerScaleEvent event, double height) {
    return height * pow(2, log(event.scale) / 4);
  }

  double scroll(PointerScrollEvent event, double height) {
    return height + event.scrollDelta.dy.sign * -1 * _scrollSensitivity;
  }

  void update(double height, double newHeight) {
    final clamped = newHeight.clamp(_min, _max);

    final zoomRatio = clamped / height;
    final scrollPosition = scrollController?.position.pixels;
    if (scrollPosition == null) return;

    final pointerPosition = scrollPosition + _yOffset;
    final newPosition = (pointerPosition * zoomRatio) - _yOffset;
    scrollController?.jumpTo(newPosition);
    heightPerMinute?.value = clamped;
  }
}
