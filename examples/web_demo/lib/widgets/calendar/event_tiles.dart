import 'package:flutter/material.dart';
import 'package:web_demo/models/event.dart';

abstract class BaseEventTile extends StatelessWidget {
  final Event event;
  final DateTimeRange tileRange;
  const BaseEventTile({
    super.key,
    required this.event,
    required this.tileRange,
  });

  static const defaultColor = Color(0xFF6366F1);
  Color get color => event.color ?? defaultColor;

  bool get continuesAfter => event.dateTimeRange.end.isAfter(tileRange.end);
  bool get continuesBefore => event.dateTimeRange.start.isBefore(tileRange.start);
  String title(BuildContext context) => event.title;

  static BorderRadius defaultBorderRadius = BorderRadius.circular(6);
}

/// Resolves the blended tile color from the theme surface and event color.
Color resolveEventColor(BuildContext context, Color eventColor, double blendFactor) {
  final surfaceColor = Theme.of(context).colorScheme.surfaceContainerLow;
  return Color.lerp(surfaceColor, eventColor, blendFactor)!;
}

/// Returns the event color, falling back to [BaseEventTile.defaultColor].
Color eventColorOf(Event event) => event.color ?? BaseEventTile.defaultColor;

class EventTile extends BaseEventTile {
  const EventTile({super.key, required super.event, required super.tileRange});
  static EventTile builder(Event event, DateTimeRange tileRange) {
    return EventTile(event: event, tileRange: tileRange);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolveEventColor(context, color, isDark ? 0.25 : 0.12),
        borderRadius: BaseEventTile.defaultBorderRadius,
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          title(context),
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class MultiDayEventTile extends BaseEventTile {
  final bool overlay;
  const MultiDayEventTile({super.key, required super.event, required super.tileRange, this.overlay = false});

  static MultiDayEventTile builder(Event event, DateTimeRange tileRange) {
    return MultiDayEventTile(event: event, tileRange: tileRange);
  }

  static MultiDayEventTile overlayBuilder(Event event, DateTimeRange tileRange) {
    return MultiDayEventTile(event: event, tileRange: tileRange, overlay: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blendFactor = overlay ? (isDark ? 0.35 : 0.22) : (isDark ? 0.30 : 0.18);
    const radius = Radius.circular(6);
    final borderRadius = BorderRadius.horizontal(
      left: continuesBefore ? Radius.zero : radius,
      right: continuesAfter ? Radius.zero : radius,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolveEventColor(context, color, blendFactor),
        borderRadius: borderRadius,
        border: continuesBefore ? null : Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        child: Row(
          children: [
            if (continuesBefore) Icon(Icons.chevron_left, size: 14, color: color.withAlpha(150)),
            Expanded(
              child: Text(
                title(context),
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (continuesAfter) Icon(Icons.chevron_right, size: 14, color: color.withAlpha(150)),
          ],
        ),
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final Event event;
  final Size dropTargetWidgetSize;
  const FeedbackTile({super.key, required this.event, required this.dropTargetWidgetSize});
  static FeedbackTile builder(Event event, Size dropTargetWidgetSize) {
    return FeedbackTile(event: event, dropTargetWidgetSize: dropTargetWidgetSize);
  }

  @override
  Widget build(BuildContext context) {
    final color = eventColorOf(event);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: dropTargetWidgetSize.width * 0.85,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(
        color: resolveEventColor(context, color, 0.18),
        borderRadius: BaseEventTile.defaultBorderRadius,
        border: Border(left: BorderSide(color: color, width: 3)),
        boxShadow: [
          BoxShadow(color: color.withAlpha(40), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
    );
  }
}

class DropTargetTile extends StatelessWidget {
  final Event event;
  const DropTargetTile({super.key, required this.event});
  static DropTargetTile builder(Event event) {
    return DropTargetTile(event: event);
  }

  @override
  Widget build(BuildContext context) {
    final color = eventColorOf(event);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolveEventColor(context, color, 0.08).withAlpha(80),
        border: Border.all(color: color.withAlpha(80), width: 1.5),
        borderRadius: BaseEventTile.defaultBorderRadius,
      ),
    );
  }
}

class TileWhenDragging extends StatelessWidget {
  final Event event;
  const TileWhenDragging({super.key, required this.event});
  static TileWhenDragging builder(Event event) {
    return TileWhenDragging(event: event);
  }

  @override
  Widget build(BuildContext context) {
    final color = eventColorOf(event);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolveEventColor(context, color, 0.06),
        border: Border(left: BorderSide(color: color.withAlpha(60), width: 3)),
        borderRadius: BaseEventTile.defaultBorderRadius,
      ),
    );
  }
}
