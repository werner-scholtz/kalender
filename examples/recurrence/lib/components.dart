import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurring_event.dart';

TileComponents tileComponents(BuildContext context, {bool body = true}) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final onColor = Theme.of(context).colorScheme.onPrimaryContainer;
  final radius = BorderRadius.circular(8);
  return TileComponents(
    tileBuilder: (event, tileRange) {
      final isRecurring = event is RecurringCalendarEvent;
      return Card(
        margin: body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              if (isRecurring) Icon(Icons.repeat, size: 14, color: onColor),
              if (isRecurring) const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _formatTileRange(context, tileRange),
                  style: TextStyle(fontSize: 12, color: onColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
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
    verticalResizeHandle: Center(
      child: Container(
        width: 32,
        height: 6,
        decoration: BoxDecoration(color: onColor.withAlpha(180), borderRadius: BorderRadius.circular(2)),
      ),
    ),
    horizontalResizeHandle: Center(
      child: Container(
        width: 6,
        height: 32,
        decoration: BoxDecoration(color: onColor.withAlpha(180), borderRadius: BorderRadius.circular(2)),
      ),
    ),
  );
}

ScheduleTileComponents scheduleTileComponents(BuildContext context) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final onColor = Theme.of(context).colorScheme.onPrimaryContainer;
  return ScheduleTileComponents(
    tileBuilder: (event, tileRange) {
      final isRecurring = event is RecurringCalendarEvent;
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 1),
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              if (isRecurring) Icon(Icons.repeat, size: 14, color: onColor),
              if (isRecurring) const SizedBox(width: 4),
              Text(
                _formatTileRange(context, tileRange),
                style: TextStyle(fontSize: 12, color: onColor),
              ),
            ],
          ),
        ),
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

String _formatTileRange(BuildContext context, DateTimeRange tileRange) {
  final localizations = MaterialLocalizations.of(context);
  final start = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(tileRange.start));
  final end = localizations.formatTimeOfDay(TimeOfDay.fromDateTime(tileRange.end));
  return '$start - $end';
}
