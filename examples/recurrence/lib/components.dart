import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

TileComponents tileComponents(BuildContext context, {bool body = true}) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final radius = BorderRadius.circular(8);
  return TileComponents(
    tileBuilder: (event, tileRange) {
      return Card(
        margin: body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),
        color: color,
        child: Text("Event"),
      );
    },
    dropTargetTile: (event) => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
        borderRadius: radius,
      ),
    ),
    feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(color: color.withAlpha(100), borderRadius: radius),
    ),
    tileWhenDraggingBuilder: (event) => Container(
      decoration: BoxDecoration(color: color.withAlpha(80), borderRadius: radius),
    ),
    dragAnchorStrategy: pointerDragAnchorStrategy,
  );
}

ScheduleTileComponents scheduleTileComponents(BuildContext context) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  return ScheduleTileComponents(
    tileBuilder: (event, tileRange) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: color,
        child: Text("Event"),
      );
    },
    dropTargetTile: (event) => DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}