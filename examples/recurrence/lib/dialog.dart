import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:recurrence/recurrence.dart';

class RecurrenceDialog extends StatefulWidget {
  final CalendarEvent event;
  const RecurrenceDialog(this.event, {super.key});

  @override
  State<RecurrenceDialog> createState() => _RecurrenceDialogState();
}

class _RecurrenceDialogState extends State<RecurrenceDialog> {
  RecurrenceType type = RecurrenceType.none;
  late DateTimeRange dateTimeRange = widget.event.dateTimeRangeAsUtc();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Do you want this event to recur ?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(Icons.play_arrow),
              Text(formatDate(widget.event.dateTimeRangeAsUtc().start)),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Icon(Icons.stop),
              Text(formatDate(widget.event.dateTimeRangeAsUtc().end)),
            ],
          ),
          DropdownMenu<RecurrenceType>(
            initialSelection: type,
            label: Text("Recurrence Type"),
            onSelected: (value) => setState(() => type = value ?? type),
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: RecurrenceType.none,
                label: 'None',
              ),
              DropdownMenuEntry(
                value: RecurrenceType.daily,
                label: 'daily',
              ),
            ],
          ),
          if (type != RecurrenceType.none) ...[
            FilledButton(
              onPressed: () async {
                final recurrence = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().endOfMonth,
                  initialDateRange: DateTimeRange(start: widget.event.startAsUtc(), end: widget.event.endAsUtc()),
                );

                if (recurrence == null) return;
                setState(() {
                  dateTimeRange = DateTimeRange(start: recurrence.start.startOfDay, end: recurrence.end.endOfDay);
                });
              },
              child: Text(
                "${MaterialLocalizations.of(context).formatCompactDate(dateTimeRange.start)} - ${MaterialLocalizations.of(context).formatCompactDate(dateTimeRange.end)}",
              ),
            ),
          ],
          FilledButton(
            onPressed: () {
              final recurrence = Recurrence.fromDateTimeRange(
                eventRange: widget.event.dateTimeRangeAsUtc(),
                recurrenceRange: dateTimeRange,
                type: type,
              );

              Navigator.pop(context, recurrence);
            },
            child: Text("ok"),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    return "${MaterialLocalizations.of(context).formatCompactDate(date)} ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(date))}";
  }
}
