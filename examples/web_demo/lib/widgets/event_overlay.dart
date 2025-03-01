import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';

class EventOverlayCard extends StatefulWidget {
  final CalendarEvent<Event> event;
  final Offset position;
  final double height;
  final double width;
  final VoidCallback onDismiss;
  final EventsController eventsController;

  const EventOverlayCard({
    super.key,
    required this.event,
    required this.position,
    required this.height,
    required this.width,
    required this.onDismiss,
    required this.eventsController,
  });

  @override
  State<EventOverlayCard> createState() => _EventOverlayCardState();
}

class _EventOverlayCardState extends State<EventOverlayCard> {
  late CalendarEvent<Event> event = widget.event;
  late CalendarEvent<Event> displayEvent = widget.event;

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 2);
    final locale = MaterialLocalizations.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: TextFormField(
                          initialValue: event.data?.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Title"),
                          onChanged: (value) {
                            final updatedEvent = event.copyWith(data: event.data?.copyWith(title: value));
                            widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                            setState(() => event = updatedEvent);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: () => widget.onDismiss(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: contentPadding,
                leading: const Icon(Icons.play_arrow),
                title: TextButton(
                  onPressed: () async {
                    final date = await _showDatePicker(DateTime(1970), event.endAsUtc);
                    if (date == null) return;

                    final newRange = DateTimeRange(start: date, end: event.endAsUtc);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(locale.formatShortDate(event.startAsUtc)),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(event.startAsUtc);
                    if (time == null) return;
                    final start = event.startAsUtc.copyWith(hour: time.hour, minute: time.minute);
                    if (start.isAfter(event.endAsUtc) || start == event.endAsUtc) return;

                    final newRange = DateTimeRange(start: start, end: event.endAsUtc);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(event.startAsUtc), alwaysUse24HourFormat: use24),
                  ),
                ),
              ),
              ListTile(
                contentPadding: contentPadding,
                leading: const Icon(Icons.stop),
                title: TextButton(
                  onPressed: () async {
                    final last = DateTime.now().addDays(365);
                    final date = await _showDatePicker(event.startAsUtc, last);
                    if (date == null) return;

                    final newRange = DateTimeRange(start: event.startAsUtc, end: date);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(locale.formatShortDate(event.endAsUtc)),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(event.endAsUtc);
                    if (time == null) return;
                    final end = event.endAsUtc.copyWith(hour: time.hour, minute: time.minute);
                    if (end.isBefore(event.startAsUtc) || end == event.startAsUtc) return;

                    final newRange = DateTimeRange(start: event.startAsUtc, end: end);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(event.endAsUtc), alwaysUse24HourFormat: use24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _showDatePicker(DateTime first, DateTime last) async {
    return showDatePicker(
      context: context,
      firstDate: first,
      lastDate: last,
    );
  }

  Future<TimeOfDay?> _showTimePicker(DateTime date) async {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
    );
  }
}
