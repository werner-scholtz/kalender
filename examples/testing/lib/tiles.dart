import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:testing/test_configuration.dart';

abstract class BaseEventTile extends StatelessWidget {
  final CalendarEvent<Event> event;
  final DateTimeRange tileRange;
  const BaseEventTile({super.key, required this.event, required this.tileRange});

  static const defaultColor = Colors.blueGrey;
  Color get color => event.data?.color ?? defaultColor;
  Color textColor(Color color) => color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  bool get continuesAfter => event.dateTimeRange.end.isAfter(tileRange.end);
  bool get continuesBefore => event.dateTimeRange.start.isBefore(tileRange.start);
  String title(BuildContext context) => event.data?.title ?? "New Event";

  static BorderRadius defaultBorderRadius = BorderRadius.circular(8);
  BoxDecoration get decoration =>
      BoxDecoration(color: color.withAlpha(150), borderRadius: defaultBorderRadius);
}

class EventTile extends BaseEventTile {
  const EventTile({super.key, required super.event, required super.tileRange});
  static EventTile builder(CalendarEvent<Event> event, DateTimeRange tileRange) {
    return EventTile(event: event, tileRange: tileRange);
  }

  EdgeInsets get padding => const EdgeInsets.all(4);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: padding,
        child: Text(title(context), style: TextStyle(color: textColor(color))),
      ),
    );
  }
}

class MultiDayEventTile extends BaseEventTile {
  const MultiDayEventTile({super.key, required super.event, required super.tileRange});
  static MultiDayEventTile builder(CalendarEvent<Event> event, DateTimeRange tileRange) {
    return MultiDayEventTile(event: event, tileRange: tileRange);
  }

  EdgeInsets get padding => const EdgeInsets.symmetric(vertical: 1, horizontal: 4);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: Padding(
        padding: padding,
        child: Text(title(context), style: TextStyle(color: textColor(color))),
      ),
    );
  }
}

class OverlayEventTile extends BaseEventTile {
  const OverlayEventTile({super.key, required super.event, required super.tileRange});

  static OverlayEventTile builder(CalendarEvent<Event> event, DateTimeRange tileRange) {
    return OverlayEventTile(event: event, tileRange: tileRange);
  }

  EdgeInsets get padding => const EdgeInsets.symmetric(vertical: 1, horizontal: 4);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          left: continuesBefore ? 20 : 0,
          right: continuesAfter ? 20 : 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color.withAlpha(150),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: padding,
              child: Text(title(context), style: TextStyle(color: textColor(color))),
            ),
          ),
        ),
        if (continuesAfter)
          const Align(alignment: Alignment.centerRight, child: Icon(Icons.chevron_right)),
        if (continuesBefore)
          const Align(alignment: Alignment.centerLeft, child: Icon(Icons.chevron_left)),
      ],
    );
  }
}

class FeedbackTile extends StatelessWidget {
  final CalendarEvent<Event> event;
  final Size dropTargetWidgetSize;
  const FeedbackTile({super.key, required this.event, required this.dropTargetWidgetSize});
  static FeedbackTile builder(CalendarEvent<Event> event, Size dropTargetWidgetSize) {
    return FeedbackTile(event: event, dropTargetWidgetSize: dropTargetWidgetSize);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: dropTargetWidgetSize.width * 0.8,
      height: dropTargetWidgetSize.height,
      decoration: BoxDecoration(
        color: (event.data?.color ?? BaseEventTile.defaultColor).withAlpha(150),
        borderRadius: BaseEventTile.defaultBorderRadius,
      ),
    );
  }
}

class DropTargetTile extends StatelessWidget {
  final CalendarEvent<Event> event;
  const DropTargetTile({super.key, required this.event});
  static DropTargetTile builder(CalendarEvent<Event> event) {
    return DropTargetTile(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: (event.data?.color ?? BaseEventTile.defaultColor), width: 2),
        borderRadius: BaseEventTile.defaultBorderRadius,
      ),
    );
  }
}

class TileWhenDragging extends StatelessWidget {
  final CalendarEvent<Event> event;
  const TileWhenDragging({super.key, required this.event});
  static TileWhenDragging builder(CalendarEvent<Event> event) {
    return TileWhenDragging(event: event);
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: (event.data?.color ?? BaseEventTile.defaultColor).withAlpha(20),
        borderRadius: BaseEventTile.defaultBorderRadius,
      ),
    );
  }
}
