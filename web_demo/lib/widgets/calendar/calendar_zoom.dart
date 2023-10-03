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
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    _currentZoom = widget.controller.heightPerMinute?.value ?? 0.7;
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
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (event) {
          if (_isCtrlPressed && event is PointerScrollEvent) {
            setState(() {
              final oldZoom = _currentZoom;
              if (event.scrollDelta.dy > 0) {
                _currentZoom -= 0.1;
                if (_currentZoom < 0.3) {
                  _currentZoom = 0.3;
                }
              } else {
                _currentZoom += 0.1;
                if (_currentZoom > 6.0) {
                  _currentZoom = 6.0;
                }
              }

              final scrollController = widget.controller.scrollController;
              if (scrollController != null) {
                final pointerPosition =
                    _pointerY / scrollController.position.viewportDimension;

                final newPosition = ((scrollController.position.pixels +
                            pointerPosition *
                                scrollController.position.viewportDimension) *
                        _currentZoom /
                        oldZoom) -
                    pointerPosition *
                        scrollController.position.viewportDimension;

                if (newPosition.isFinite) {
                  scrollController.jumpTo(newPosition);
                }
              }

              widget.controller.adjustHeightPerMinute(_currentZoom);
            });
          }
        },
      ),
    );
  }

  bool _onKey(KeyEvent event) {
    if (!mounted) return false;

    final key = event.logicalKey;
    if (event is KeyDownEvent && key == LogicalKeyboardKey.controlLeft) {
      setState(() {
        widget.controller.lockScrollPhysics();
        _isCtrlPressed = true;
      });
    } else if (event is KeyUpEvent && key == LogicalKeyboardKey.controlLeft) {
      setState(() {
        widget.controller.unlockScrollPhysics();
        _isCtrlPressed = false;
      });
    }

    return false;
  }
}
