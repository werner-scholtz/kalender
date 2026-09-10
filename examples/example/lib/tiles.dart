import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

/// The tile widgets, each with a static `builder`.
///
/// Kept out of `main.dart` so the calendar setup there stays readable. Each
/// tile reads the theme from its own context rather than capturing it from the
/// enclosing build, which is what lets the builder be a static function and the
/// components be a single `const`.
///
/// An inline builder works just as well. This is a readability choice.

Color eventColor(BuildContext context, KalenderEvent event) =>
    (event is Event ? event.color : null) ?? Theme.of(context).colorScheme.primaryContainer;

BorderRadius get _radius => BorderRadius.circular(8);

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.event});

  final KalenderEvent event;

  static EventTile builder(BuildContext context, KalenderEvent event, KalenderDateTimeRange tileRange) =>
      EventTile(event: event);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: eventColor(context, event),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          (event is Event) ? (event as Event).title : '',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 12),
        ),
      ),
    );
  }
}

class DropTargetTile extends StatelessWidget {
  const DropTargetTile({super.key});

  static DropTargetTile builder(BuildContext context, KalenderEvent event) => const DropTargetTile();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurface.withAlpha(80), width: 2),
        borderRadius: _radius,
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  const FeedbackTile({super.key, required this.event, required this.size});

  final KalenderEvent event;
  final Size size;

  static FeedbackTile builder(BuildContext context, KalenderEvent event, Size dropTargetWidgetSize) =>
      FeedbackTile(event: event, size: dropTargetWidgetSize);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size.width * 0.8,
      height: size.height,
      decoration: BoxDecoration(color: eventColor(context, event).withAlpha(100), borderRadius: _radius),
    );
  }
}

class TileWhenDragging extends StatelessWidget {
  const TileWhenDragging({super.key, required this.event});

  final KalenderEvent event;

  static TileWhenDragging builder(BuildContext context, KalenderEvent event) => TileWhenDragging(event: event);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: eventColor(context, event).withAlpha(80), borderRadius: _radius),
    );
  }
}

/// Reads its color from the theme, so both handles can be one const widget.
class ResizeHandle extends StatelessWidget {
  const ResizeHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimaryContainer.withAlpha(150),
        shape: BoxShape.circle,
      ),
    );
  }
}

class ScheduleEventTile extends StatelessWidget {
  const ScheduleEventTile({super.key, required this.event});

  final KalenderEvent event;

  static ScheduleEventTile builder(BuildContext context, KalenderEvent event, KalenderDateTimeRange tileRange) =>
      ScheduleEventTile(event: event);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1),
      color: eventColor(context, event),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text((event is Event) ? (event as Event).title : ''),
      ),
    );
  }
}

/// Declared once rather than rebuilt by a method called from `build`.
const tileComponents = TileComponents(
  tileBuilder: EventTile.builder,
  dropTargetTile: DropTargetTile.builder,
  feedbackTileBuilder: FeedbackTile.builder,
  tileWhenDraggingBuilder: TileWhenDragging.builder,
  dragAnchorStrategy: pointerDragAnchorStrategy,
  verticalResizeHandle: ResizeHandle(),
  horizontalResizeHandle: ResizeHandle(),
);

const scheduleTileComponents = ScheduleTileComponents(tileBuilder: ScheduleEventTile.builder);
