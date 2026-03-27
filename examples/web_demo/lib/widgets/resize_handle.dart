import 'package:flutter/material.dart';
import 'package:web_demo/utils.dart';

class VerticalResizeHandle extends StatefulWidget {
  const VerticalResizeHandle({super.key});

  @override
  State<VerticalResizeHandle> createState() => _VerticalResizeHandleState();
}

class _VerticalResizeHandleState extends State<VerticalResizeHandle> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    // On touch devices the library only mounts this widget when the event is
    // selected, so always render the visible state. On desktop, use hover.
    final active = isTouch || hovering;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: active
          ? const EdgeInsets.symmetric(vertical: 3, horizontal: 12)
          : const EdgeInsets.symmetric(vertical: 3, horizontal: 32),
      decoration: BoxDecoration(
        color: active ? context.colorScheme.primary.withAlpha(80) : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    if (isTouch) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeUp,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: child,
    );
  }
}

class HorizontalResizeHandle extends StatefulWidget {
  const HorizontalResizeHandle({super.key});

  @override
  State<HorizontalResizeHandle> createState() => _HorizontalResizeHandleState();
}

class _HorizontalResizeHandleState extends State<HorizontalResizeHandle> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = isTouch || hovering;

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: active
          ? const EdgeInsets.symmetric(vertical: 6, horizontal: 2)
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: active ? colorScheme.primary.withAlpha(80) : Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
    );

    if (isTouch) return child;

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: child,
    );
  }
}
