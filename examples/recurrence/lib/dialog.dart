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
  late DateTimeRange dateTimeRange = widget.event.dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Recurrence ?"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownMenu<RecurrenceType>(
            initialSelection: type,
            label: Text("Type"),
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
          Text(widget.event.dateTimeRange.toString()),
          if (type != RecurrenceType.none) ...[
            FilledButton(
              onPressed: () async {
                final recurrence = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now().endOfMonth,
                  initialDateRange: DateTimeRange(start: widget.event.start, end: widget.event.end),
                );

                if (recurrence == null) return;
                setState(() {
                  dateTimeRange = DateTimeRange(start: recurrence.start.startOfDay, end: recurrence.end.endOfDay);
                });
              },
              child: Text(dateTimeRange.toString()),
            ),
          ],
          FilledButton(
            onPressed: () {
              final recurrence = Recurrence.fromDateTimeRange(
                eventRange: widget.event.dateTimeRange,
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
}
