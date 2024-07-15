import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';

class EventOverlayCard extends StatelessWidget {
  final CalendarEvent<Event> event;
  final Offset position;
  final double height;
  final double width;
  final VoidCallback onDismiss;

  const EventOverlayCard({
    super.key,
    required this.event,
    required this.position,
    required this.height,
    required this.width,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      event.data!.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () => onDismiss(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
