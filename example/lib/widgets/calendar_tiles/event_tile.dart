import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
    required this.tileType,
    required this.drawOutline,
    required this.continuesBefore,
    required this.continuesAfter,
  });

  final CalendarEvent<Event> event;
  final TileType tileType;
  final bool drawOutline;
  final bool continuesBefore;
  final bool continuesAfter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color(event.eventData?.color ?? Colors.blue),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(continuesBefore ? 0 : 8),
          bottomLeft: Radius.circular(continuesAfter ? 0 : 8),
          topRight: Radius.circular(continuesBefore ? 0 : 8),
          bottomRight: Radius.circular(continuesAfter ? 0 : 8),
        ),
        border: drawOutline || tileType == TileType.selected
            ? Border.all(color: Theme.of(context).colorScheme.onBackground)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: event.eventData?.title ?? '',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: event.eventData?.description ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color color(Color color) {
    if (tileType == TileType.ghost) {
      return color.withAlpha(100);
    } else {
      return color;
    }
  }

  double get elevation {
    switch (tileType) {
      case TileType.ghost:
        return 0.0;
      case TileType.normal:
        return 4.0;
      case TileType.selected:
        return 8.0;
      default:
        return 0.0;
    }
  }
}
