import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:web_demo/models/event.dart';
import 'package:web_demo/utils.dart';

class EventDetailCard extends StatefulWidget {
  final Event event;
  final Offset position;
  final double height;
  final double width;
  final VoidCallback onDismiss;
  final EventsController eventsController;
  final Location? location;

  const EventDetailCard({
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
  State<EventDetailCard> createState() => _EventDetailCardState();
}

class _EventDetailCardState extends State<EventDetailCard> {
  late Event event = widget.event;

  Location? get _location => widget.location;

  @override
  Widget build(BuildContext context) {
    final locale = MaterialLocalizations.of(context);
    final use24 = MediaQuery.alwaysUse24HourFormatOf(context);
    final colorScheme = Theme.of(context).colorScheme;
    final eventColor = event.color ?? Colors.blueGrey;

    final displayStart = event.internalStart(location: _location);
    final displayEnd = event.internalEnd(location: _location);

    return Card(
      elevation: 8,
      shadowColor: colorScheme.shadow.withAlpha(60),
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Column(
            children: [
              // Color accent bar at top
              Container(
                height: 4,
                color: eventColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Column(
                    children: [
                      // Title row
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 36,
                            decoration: BoxDecoration(
                              color: eventColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: event.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorScheme.primary),
                                ),
                                hintText: context.l10n.title,
                                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                final updatedEvent = event.copyWith(title: value);
                                widget.eventsController.updateEvent(event: event, updatedEvent: updatedEvent);
                                setState(() => event = updatedEvent);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => widget.onDismiss(),
                            icon: const Icon(Icons.close, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              minimumSize: const Size(32, 32),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Start time row
                      _DateTimeRow(
                        icon: Icons.play_circle_outline,
                        iconColor: Colors.green,
                        label: context.l10n.start,
                        dateText: locale.formatShortDate(displayStart),
                        timeText: locale.formatTimeOfDay(
                          TimeOfDay.fromDateTime(displayStart),
                          alwaysUse24HourFormat: use24,
                        ),
                        onDateTap: () async {
                          final date = await _showDatePicker(DateTime(1970), displayEnd);
                          if (date == null) return;
                          final newStart =
                              _toUtc(date.year, date.month, date.day, displayStart.hour, displayStart.minute);
                          final newEnd = _toUtc(
                            displayEnd.year,
                            displayEnd.month,
                            displayEnd.day,
                            displayEnd.hour,
                            displayEnd.minute,
                          );
                          if (newStart.isAfter(newEnd)) return;
                          _updateEvent(DateTimeRange(start: newStart, end: newEnd));
                        },
                        onTimeTap: () async {
                          final time = await _showTimePicker(displayStart);
                          if (time == null) return;
                          final newStart =
                              _toUtc(displayStart.year, displayStart.month, displayStart.day, time.hour, time.minute);
                          if (newStart.isAfter(event.end)) return;
                          _updateEvent(DateTimeRange(start: newStart, end: event.end));
                        },
                      ),
                      const SizedBox(height: 4),
                      // End time row
                      _DateTimeRow(
                        icon: Icons.stop_circle_outlined,
                        iconColor: colorScheme.error,
                        label: context.l10n.end,
                        dateText: locale.formatShortDate(displayEnd),
                        timeText: locale.formatTimeOfDay(
                          TimeOfDay.fromDateTime(displayEnd),
                          alwaysUse24HourFormat: use24,
                        ),
                        onDateTap: () async {
                          final now = DateTime.now();
                          final last = now.copyWith(day: now.day + 365);
                          final date = await _showDatePicker(displayStart, last);
                          if (date == null) return;
                          final newEnd = _toUtc(date.year, date.month, date.day, displayEnd.hour, displayEnd.minute);
                          if (newEnd.isBefore(event.start)) return;
                          _updateEvent(DateTimeRange(start: event.start, end: newEnd));
                        },
                        onTimeTap: () async {
                          final time = await _showTimePicker(displayEnd);
                          if (time == null) return;
                          final newEnd =
                              _toUtc(displayEnd.year, displayEnd.month, displayEnd.day, time.hour, time.minute);
                          if (newEnd.isBefore(event.start)) return;
                          _updateEvent(DateTimeRange(start: event.start, end: newEnd));
                        },
                      ),
                      const Spacer(),
                      // Delete button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            widget.eventsController.removeEvent(event);
                            widget.onDismiss();
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: Text(context.l10n.delete),
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.errorContainer,
                            foregroundColor: colorScheme.onErrorContainer,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
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

class _DateTimeRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String dateText;
  final String timeText;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const _DateTimeRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.dateText,
    required this.timeText,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 12),
        InkWell(
          onTap: onDateTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh.withAlpha(120),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(dateText, style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onTimeTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh.withAlpha(120),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(timeText, style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
      ],
    );
  }
}
