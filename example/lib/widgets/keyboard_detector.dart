import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalender/kalender.dart';

class CalendarKeyboardDetector extends StatefulWidget {
  const CalendarKeyboardDetector({
    super.key,
    required this.controller,
    required this.onZoom,
    required this.child,
  });
  final Widget child;
  final CalendarController controller;
  final void Function(double heightPerMinute) onZoom;

  @override
  State<CalendarKeyboardDetector> createState() =>
      _CalendarKeyboardDetectorState();
}

class _CalendarKeyboardDetectorState extends State<CalendarKeyboardDetector> {
  final FocusNode _focusNode = FocusNode();
  bool _isCtrlPressed = false;

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: (value) {
        setState(() {
          if (value.isKeyPressed(LogicalKeyboardKey.controlLeft)) {
            _isCtrlPressed = true;
          } else {
            _isCtrlPressed = false;
          }
        });
      },
      child: Listener(
        onPointerSignal: (notification) {
          if (notification is PointerScrollEvent && _isCtrlPressed) {
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

    widget.onZoom(newHeightPerMinute);
  }
}
