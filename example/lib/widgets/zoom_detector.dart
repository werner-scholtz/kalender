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
  final Widget child;
  final CalendarController controller;

  @override
  State<CalendarZoomDetector> createState() => _CalendarZoomDetectorState();
}

class _CalendarZoomDetectorState extends State<CalendarZoomDetector> {
  final FocusNode focusNode = FocusNode();
  bool isCtrlPressed = false;

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      onKey: (value) {
        setState(() {
          if (value.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
            isCtrlPressed = true;
          } else {
            isCtrlPressed = false;
          }
        });
      },
      child: Listener(
        onPointerSignal: (notification) {
          if (notification is PointerScrollEvent && isCtrlPressed) {
            _handlePointerScrollEvent(notification);
          }
        },
        child: widget.child,
      ),
    );
  }

  /// Handles the pointer scroll event.
  void _handlePointerScrollEvent(PointerScrollEvent notification) {
    double? newHeightPerMinute = widget.controller.heightPerMinute;
    if (newHeightPerMinute == null) return;

    newHeightPerMinute =
        newHeightPerMinute + notification.scrollDelta.dy / 1000;

    if (newHeightPerMinute < 0.3) {
      newHeightPerMinute = 0.3;
    }

    if (newHeightPerMinute > 2) {
      newHeightPerMinute = 2;
    }
    widget.controller.adjustHeightPerMinute(newHeightPerMinute);
  }
}
