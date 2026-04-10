import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';

class ResizeHandle extends StatefulWidget {
  final Axis axis;
  const ResizeHandle({super.key, required this.axis});

  const ResizeHandle.vertical({super.key}) : axis = Axis.vertical;
  const ResizeHandle.horizontal({super.key}) : axis = Axis.horizontal;

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  bool hovering = false;

  EdgeInsets get _margin {
    return widget.axis == Axis.vertical
        ? EdgeInsets.symmetric(vertical: 3, horizontal: isTouch ? 3 : 6)
        : EdgeInsets.symmetric(vertical: isTouch ? 1 : 3, horizontal: isTouch ? 1 : 4);
  }

  BorderRadius get _borderRadius => BorderRadius.circular(isTouch ? 4 : 2);

  MouseCursor get _cursor =>
      widget.axis == Axis.vertical ? SystemMouseCursors.resizeUp : SystemMouseCursors.resizeLeftRight;

  @override
  Widget build(BuildContext context) {
    final active = isTouch || hovering;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: _margin,
      decoration: BoxDecoration(
        color: active ? context.colorScheme.primary.withAlpha(80) : Colors.transparent,
        borderRadius: _borderRadius,
      ),
    );

    if (isTouch) return child;

    return MouseRegion(
      cursor: _cursor,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: child,
    );
  }
}
