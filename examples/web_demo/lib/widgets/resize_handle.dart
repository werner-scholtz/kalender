import 'package:flutter/material.dart';

class ResizeHandle extends StatefulWidget {
  const ResizeHandle({super.key});

  @override
  State<ResizeHandle> createState() => _ResizeHandleState();
}

class _ResizeHandleState extends State<ResizeHandle> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurface.withOpacity(0.5);

    return MouseRegion(
      cursor: SystemMouseCursors.resizeUp,
      onEnter: (event) => setState(() => hovering = true),
      onExit: (event) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: hovering ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
