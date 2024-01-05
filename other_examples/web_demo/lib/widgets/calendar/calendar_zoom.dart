import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

class CalendarZoomDetector extends StatefulWidget {
  const CalendarZoomDetector({
    super.key,
    required this.controller,
    required this.child,
  });

  final CalendarController controller;
  final Widget child;

  @override
  State<CalendarZoomDetector> createState() => _CalendarZoomDetectorState();
}

class _CalendarZoomDetectorState extends State<CalendarZoomDetector> {
  bool _isCtrlPressed = false;
  double _pointerY = 0.0;
  double _currentZoom = 0.7;
  double _initialZoom = 0.7;

  @override
  void initState() {
    super.initState();
    // ServicesBinding.instance.keyboard.addHandler(_onKey);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      View.of(context).platformDispatcher.onKeyData = _onKey;
    });

    _currentZoom = widget.controller.heightPerMinute?.value ?? 0.7;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (event) {
        setState(() {
          _pointerY = event.localPosition.dy;
        });
      },
      onHover: (event) {
        setState(() {
          _pointerY = event.localPosition.dy;
        });
      },
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: {
          AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              AllowMultipleGestureRecognizer>(
            AllowMultipleGestureRecognizer.new, //constructor
            (instance) {
              instance.onStart = (details) {
                _initialZoom = _currentZoom;

                if (details.pointerCount <= 1) return;
                widget.controller.lockScrollPhysics();
              };
              instance.onUpdate = (details) {
                if (details.pointerCount <= 1) return;

                final oldZoom = _currentZoom;
                _currentZoom =
                    (_initialZoom * details.verticalScale).clamp(0.3, 6.0);

                final scrollController = widget.controller.scrollController;
                if (scrollController == null) return;
                final newPosition = calculateScrollPosition(
                      scrollController,
                      oldZoom,
                    ).clamp(
                      scrollController.position.minScrollExtent,
                      scrollController.position.maxScrollExtent,
                    ) -
                    details.focalPointDelta.dy;

                if (newPosition.isFinite) {
                  scrollController.jumpTo(newPosition);
                }

                widget.controller.adjustHeightPerMinute(_currentZoom);
              };
              instance.onEnd = (details) {
                widget.controller.unlockScrollPhysics();
              };
            },
          ),
        },
        child: Listener(
          onPointerSignal: (event) {
            if (_isCtrlPressed) {
              if (event is PointerScrollEvent) {
                setState(() {
                  final oldZoom = _currentZoom;

                  var newZoom = _currentZoom;
                  if (event.scrollDelta.dy > 0) {
                    newZoom -= 0.1;
                  } else {
                    newZoom += 0.1;
                  }
                  _currentZoom = newZoom.clamp(0.3, 6.0);

                  final scrollController = widget.controller.scrollController;
                  if (scrollController != null) {
                    final newPosition = calculateScrollPosition(
                      scrollController,
                      oldZoom,
                    );

                    if (newPosition.isFinite) {
                      scrollController.jumpTo(newPosition);
                    }
                  }

                  widget.controller.adjustHeightPerMinute(_currentZoom);
                });
              }

              if (event is PointerScaleEvent) {
                setState(() {
                  final oldZoom = _currentZoom;

                  double newZoom = _currentZoom;
                  if (event.scale > 1) {
                    newZoom += 0.1;
                  } else {
                    newZoom -= 0.1;
                  }
                  _currentZoom = newZoom.clamp(0.3, 6.0);

                  final scrollController = widget.controller.scrollController;
                  if (scrollController != null) {
                    final newPosition = calculateScrollPosition(
                      scrollController,
                      oldZoom,
                    );

                    if (newPosition.isFinite) {
                      scrollController.jumpTo(newPosition);
                    }
                  }

                  widget.controller.adjustHeightPerMinute(_currentZoom);
                });
              }
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  bool _onKey(KeyData event) {
    if (!mounted) return false;

    final key = event.logical;

    if (key == LogicalKeyboardKey.controlLeft.keyId ||
        key == LogicalKeyboardKey.controlRight.keyId) {
      if (event.type == KeyEventType.down) {
        _startZoom();
        return true;
      }

      if (event.type == KeyEventType.up) {
        _endZoom();
        return true;
      }
    }

    return false;
  }

  void _startZoom() {
    setState(() {
      widget.controller.lockScrollPhysics();
      _isCtrlPressed = true;
    });
  }

  void _endZoom() {
    setState(() {
      widget.controller.unlockScrollPhysics();
      _isCtrlPressed = false;
    });
  }

  double calculateScrollPosition(
    ScrollController scrollController,
    double oldZoom,
  ) {
    // Get the height of the visible portion of the content
    final viewportHeight = scrollController.position.viewportDimension;

    // Calculate the ratio of the pointer's position within the viewport to the viewport's total height.
    final pointerPosition = _pointerY / viewportHeight;

    // Calculate the ratio of the new zoom level to the previous zoom level
    final zoomRatio = _currentZoom / oldZoom;

    // Calculate the new scroll position.
    return ((scrollController.position.pixels +
                pointerPosition * scrollController.position.viewportDimension) *
            zoomRatio) -

        // This part ensures that the pointer's position within the viewport stays the same.
        pointerPosition * scrollController.position.viewportDimension;
  }
}

// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
