import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/utils.dart';

class EventOverlayCard extends StatefulWidget {
  final Event event;
  final Offset position;
  final double height;
  final double width;
  final VoidCallback onDismiss;
  final EventsController eventsController;
  final Location? location;

  const EventOverlayCard({
    super.key,
    required this.event,
    required this.position,
    required this.height,
    required this.width,
    required this.onDismiss,
    required this.eventsController,
    required this.location,
  });

  @override
  State<EventOverlayCard> createState() => _EventOverlayCardState();
}

class _EventOverlayCardState extends State<EventOverlayCard> {
  late Event event = widget.event;

  Location? get _location => widget.location;

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 2);
    final locale = MaterialLocalizations.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);

    final displayStart = event.internalStart(location: _location);
    final displayEnd = event.internalEnd(location: _location);

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
                          initialValue: event.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: context.l10n.title,
                          ),
                          onChanged: (value) {
                            final updatedEvent = event.copyWith(title: value);
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
                    final date = await _showDatePicker(DateTime(1970), displayEnd);
                    if (date == null) return;
                    final newStart = _toUtc(date.year, date.month, date.day, displayStart.hour, displayStart.minute);
                    final newEnd =
                        _toUtc(displayEnd.year, displayEnd.month, displayEnd.day, displayEnd.hour, displayEnd.minute);
                    if (newStart.isAfter(newEnd)) return;
                    _updateEvent(DateTimeRange(start: newStart, end: newEnd));
                  },
                  child: Text(locale.formatShortDate(displayStart)),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(displayStart);
                    if (time == null) return;
                    final newStart =
                        _toUtc(displayStart.year, displayStart.month, displayStart.day, time.hour, time.minute);
                    if (newStart.isAfter(event.end)) return;
                    _updateEvent(DateTimeRange(start: newStart, end: event.end));
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(displayStart), alwaysUse24HourFormat: use24),
                  ),
                ),
              ),
              ListTile(
                contentPadding: contentPadding,
                leading: const Icon(Icons.stop),
                title: TextButton(
                  onPressed: () async {
                    final now = DateTime.now();
                    final last = now.copyWith(day: now.day + 365);
                    final date = await _showDatePicker(displayStart, last);
                    if (date == null) return;
                    final newEnd = _toUtc(date.year, date.month, date.day, displayEnd.hour, displayEnd.minute);
                    if (newEnd.isBefore(event.start)) return;
                    _updateEvent(DateTimeRange(start: event.start, end: newEnd));
                  },
                  child: Text(locale.formatShortDate(displayEnd)),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final time = await _showTimePicker(displayEnd);
                    if (time == null) return;
                    final newEnd = _toUtc(displayEnd.year, displayEnd.month, displayEnd.day, time.hour, time.minute);
                    if (newEnd.isBefore(event.start)) return;
                    _updateEvent(DateTimeRange(start: event.start, end: newEnd));
                  },
                  child: Text(
                    locale.formatTimeOfDay(TimeOfDay.fromDateTime(displayEnd), alwaysUse24HourFormat: use24),
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.tonal(
                onPressed: () {
                  widget.eventsController.removeEvent(event);
                  widget.onDismiss();
                },
                child: Text(context.l10n.delete),
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

  /// Converts wall-clock components back to UTC via InternalDateTime.
  DateTime _toUtc(int year, int month, int day, int hour, int minute) {
    return InternalDateTime(year, month, day, hour, minute).forLocation(location: _location).toUtc();
  }

  void _updateEvent(DateTimeRange newRange) {
    final updatedEvent = event.copyWith(dateTimeRange: newRange);
    widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
    setState(() => event = updatedEvent);
  }
}
