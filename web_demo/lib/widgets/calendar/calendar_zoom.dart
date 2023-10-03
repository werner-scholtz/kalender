import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

class CalendarZoomDetector extends StatefulWidget {
  const CalendarZoomDetector({
    super.key,
    required this.controller,
  });

  final CalendarController controller;

  @override
  State<CalendarZoomDetector> createState() => _CalendarZoomDetectorState();
}

class _CalendarZoomDetectorState extends State<CalendarZoomDetector> {
  bool _isCtrlPressed = false;
  double _pointerY = 0.0;
  double _currentZoom = 0.7;

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
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onScaleStart: kIsWeb
            ? null
            : (details) {
                _startZoom();
              },
        onScaleUpdate: kIsWeb
            ? null
            : (details) {
                setState(() {
                  final oldZoom = _currentZoom;
                  _currentZoom = details.scale;
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
              },
        onScaleEnd: kIsWeb
            ? null
            : (details) {
                _endZoom();
              },
        child: Listener(
          behavior: HitTestBehavior.translucent,
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
