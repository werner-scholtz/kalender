import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class DefaultTileBase extends StatelessWidget {
  final String label;
  final Color? color;
  final double? width;
  final double? height;
  const DefaultTileBase({super.key, required this.label, this.color, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.primaryContainer.withAlpha(150),
      width: width,
      height: height,
      child: Center(child: Text(label)),
    );
  }
}

// Example builder functions for each tile type:
Widget defaultTileBuilder(CalendarEvent event, DateTimeRange tileRange) => const DefaultTileBase(label: 'Tile');
Widget defaultTileWhenDraggingBuilder(CalendarEvent event) => const DefaultTileBase(label: 'TileWhenDragging');
Widget defaultDropTargetBuilder(CalendarEvent event) => const DefaultTileBase(label: 'DropTarget');
Widget defaultFeedbackTileBuilder(CalendarEvent event, Size size) {
  return Material(child: DefaultTileBase(label: 'FeedbackTile', width: size.width, height: size.height));
}
