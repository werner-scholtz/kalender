import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:demo/data/event.dart';

class OverlayCard extends StatefulWidget {
  final CalendarEvent<Event> event;
  final Offset position;
  final double height;
  final double width;
  final VoidCallback onDismiss;
  final EventsController eventsController;

  const OverlayCard({
    super.key,
    required this.event,
    required this.position,
    required this.height,
    required this.width,
    required this.onDismiss,
    required this.eventsController,
  });

  @override
  State<OverlayCard> createState() => _OverlayCardState();
}

class _OverlayCardState extends State<OverlayCard> {
  late CalendarEvent<Event> event = widget.event;
  late CalendarEvent<Event> displayEvent = widget.event;

  MaterialLocalizations get locale => MaterialLocalizations.of(context);
  bool get use24 => MediaQuery.alwaysUse24HourFormatOf(context);

  final contentPadding = const EdgeInsets.symmetric(horizontal: 2);
  final margin = const EdgeInsets.all(8);
  final padding = const EdgeInsets.all(8);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: event.data?.title,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Title"),
                      onChanged: (value) {
                        final updatedEvent = event.copyWith(data: event.data?.copyWith(title: value));
                        widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                        setState(() => event = updatedEvent);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: () => widget.onDismiss(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: contentPadding,
                leading: const Icon(Icons.play_arrow),
                title: TextButton(
                  onPressed: () async {
                    final date = await _showDatePicker(DateTime(1970), event.endAsUtc());
                    if (date == null) return;

                    final newRange = DateTimeRange(start: date, end: event.endAsUtc());
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(locale.formatShortDate(event.startAsUtc())),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(event.startAsUtc());
                    if (time == null) return;
                    final start = event.startAsUtc().copyWith(hour: time.hour, minute: time.minute);
                    if (start.isAfter(event.endAsUtc()) || start == event.endAsUtc()) return;

                    final newRange = DateTimeRange(start: start, end: event.endAsUtc());
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(event.startAsUtc()), alwaysUse24HourFormat: use24),
                  ),
                ),
              ),
              ListTile(
                contentPadding: contentPadding,
                leading: const Icon(Icons.stop),
                title: TextButton(
                  onPressed: () async {
                    final last = DateTime.now().addDays(365);
                    final date = await _showDatePicker(event.startAsUtc(), last);
                    if (date == null) return;

                    final newRange = DateTimeRange(start: event.startAsUtc(), end: date);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(locale.formatShortDate(event.endAsUtc())),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(event.endAsUtc());
                    if (time == null) return;
                    final end = event.endAsUtc().copyWith(hour: time.hour, minute: time.minute);
                    if (end.isBefore(event.startAsUtc()) || end == event.startAsUtc()) return;

                    final newRange = DateTimeRange(start: event.startAsUtc(), end: end);
                    final updatedEvent = event.copyWith(dateTimeRange: newRange);
                    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                    setState(() => event = updatedEvent);
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(event.endAsUtc()), alwaysUse24HourFormat: use24),
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
