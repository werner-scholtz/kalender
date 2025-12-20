import 'package:demo/data/event.dart';
import 'package:flutter/material.dart';


abstract class Tile extends StatelessWidget {
  final Event event;
  final EdgeInsets margin;
  const Tile({required this.event, required this.margin, super.key});

  String get title => event.title;
  String? get description => event.description;
  Color color(BuildContext context) {
    return event.color ?? Theme.of(context).colorScheme.primaryContainer;
  }

  Color textColor(Color background) => background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

class EventTile extends Tile {
  final EdgeInsets titlePadding;
  const EventTile({
    required this.titlePadding,
    required super.margin,
    required super.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color(context).withAlpha(200),
      child: Padding(
        padding: titlePadding,
        child: Text(title, style: TextStyle(color: textColor(color(context)))),
      ),
    );
  }
}

class MultiDayEventTile extends Tile {
  const MultiDayEventTile({
    required super.margin,
    required super.event,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color(context).withAlpha(200),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Text(title, style: TextStyle(color: textColor(color(context)))),
      ),
    );
  }
}

class DropTargetTile extends Tile {
  const DropTargetTile({
    required super.event,
    required super.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onSurfaceVariant),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class TileWhenDragging extends Tile {
  const TileWhenDragging({
    required super.event,
    required super.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color(context).withAlpha(120),
    );
  }
}

class FeedbackTile extends Tile {
  final Size size;
  const FeedbackTile({
    required this.size,
    required super.event,
    required super.margin,
    super.key,
  });

  double get width => size.width * 0.8;
  double get height => size.height * 0.8;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: color(context).withAlpha(100),
      child: SizedBox(width: width, height: height),
    );
  }
}
