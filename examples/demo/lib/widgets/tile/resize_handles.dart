import 'package:flutter/material.dart';

class VerticalResizeHandle extends StatefulWidget {
  const VerticalResizeHandle({super.key});

  @override
  State<VerticalResizeHandle> createState() => _VerticalResizeHandleState();
}

class _VerticalResizeHandleState extends State<VerticalResizeHandle> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = hovering
        ? theme.colorScheme.onSurface.withOpacity(0.5)
        : Colors.transparent;
    final margin = hovering
        ? const EdgeInsets.symmetric(vertical: 4, horizontal: 8)
        : const EdgeInsets.symmetric(vertical: 4, horizontal: 32);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeUp,
      onEnter: (event) => setState(() {
        hovering = true;
      }),
      onExit: (event) => setState(() {
        hovering = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: margin,
        decoration: BoxDecoration(
          color: hovering ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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
    final theme = Theme.of(context);
    final color = hovering
        ? theme.colorScheme.onSurface.withOpacity(0.5)
        : Colors.transparent;
    final margin = hovering
        ? const EdgeInsets.symmetric(vertical: 4, horizontal: 4)
        : const EdgeInsets.symmetric(vertical: 8, horizontal: 8);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (event) => setState(() {
        hovering = true;
      }),
      onExit: (event) => setState(() {
        hovering = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: margin,
        decoration: BoxDecoration(
          color: hovering ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
