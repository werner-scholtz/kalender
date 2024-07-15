import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// A widget used to detect resizes.

enum ResizeDetectorType {
  pan,
  vertical,
  horizontal,
}

class ResizeDetectorWidget extends StatefulWidget {
  final Function(Offset delta)? onStart;
  final Function(Offset delta)? onUpdate;
  final Function(Offset delta)? onEnd;

  final ResizeDetectorType type;
  final Widget? child;

  const ResizeDetectorWidget({
    super.key,
    required this.type,
    this.onStart,
    this.onUpdate,
    this.onEnd,
    this.child,
  });

  @override
  State<ResizeDetectorWidget> createState() => _ResizeDetectorWidgetState();
}

class _ResizeDetectorWidgetState extends State<ResizeDetectorWidget> {
  Offset _start = Offset.zero;
  Offset _delta = Offset.zero;

  static const hitTestBehavior = HitTestBehavior.opaque;

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      ResizeDetectorType.pan => GestureDetector(
          behavior: hitTestBehavior,
          onPanStart: (details) {
            _start = details.globalPosition;
            widget.onStart?.call(_delta);
          },
          onPanUpdate: (details) {
            final current = details.globalPosition;
            _delta = current - _start;
            widget.onUpdate?.call(_delta);
          },
          onPanEnd: (details) {
            widget.onEnd?.call(_delta);
            _delta = Offset.zero;
          },
          child: widget.child,
        ),
      ResizeDetectorType.vertical => GestureDetector(
          behavior: hitTestBehavior,
          onVerticalDragStart: (details) {
            _start = details.globalPosition;
            widget.onStart?.call(_delta);
          },
          onVerticalDragUpdate: (details) {
            final current = details.globalPosition;
            _delta = current - _start;
            widget.onUpdate?.call(_delta);
          },
          onVerticalDragEnd: (details) {
            widget.onEnd?.call(_delta);
            _delta = Offset.zero;
          },
          child: widget.child,
        ),
      ResizeDetectorType.horizontal => GestureDetector(
          behavior: hitTestBehavior,
          onHorizontalDragStart: (details) {
            _start = details.globalPosition;
            widget.onStart?.call(_delta);
          },
          onHorizontalDragUpdate: (details) {
            final current = details.globalPosition;
            _delta = current - _start;
            widget.onUpdate?.call(_delta);
          },
          onHorizontalDragEnd: (details) {
            widget.onEnd?.call(_delta);
            _delta = Offset.zero;
          },
        ),
    };
  }
}
