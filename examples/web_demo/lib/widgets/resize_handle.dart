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
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeUp,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: hovering
            ? const EdgeInsets.symmetric(vertical: 3, horizontal: 12)
            : const EdgeInsets.symmetric(vertical: 3, horizontal: 32),
        decoration: BoxDecoration(
          color: hovering ? colorScheme.primary.withAlpha(80) : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
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
    final colorScheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: hovering
            ? const EdgeInsets.symmetric(vertical: 6, horizontal: 2)
            : const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: hovering ? colorScheme.primary.withAlpha(80) : Colors.transparent,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
