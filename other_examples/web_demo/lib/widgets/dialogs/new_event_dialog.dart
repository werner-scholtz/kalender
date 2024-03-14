import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/dialogs/date_time_range_editor.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class NewEventDialog extends StatefulWidget {
  const NewEventDialog({
    super.key,
    required this.dialogTitle,
    required this.event,
  });

  final String dialogTitle;
  final CalendarEvent<Event> event;

  @override
  State<NewEventDialog> createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<NewEventDialog> {
  late DateTimeRange dateTimeRange = widget.event.dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(widget.dialogTitle),
      children: [
        TextFormField(
          initialValue: widget.event.eventData?.title,
          decoration: const InputDecoration(
            labelText: 'Title',
            isDense: true,
          ),
          onChanged: (value) {
            widget.event.eventData =
                widget.event.eventData?.copyWith(title: value);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DateTimeRangeEditor(
            dateTimeRange: dateTimeRange,
            onStartChanged: (dateTime) {
              if (dateTime.isAfter(dateTimeRange.end)) return;
              setState(() {
                dateTimeRange = DateTimeRange(
                  start: dateTime,
                  end: dateTimeRange.end,
                );
                widget.event.dateTimeRange = dateTimeRange;
              });
            },
            onEndChanged: (dateTime) {
              if (dateTime.isBefore(dateTimeRange.start)) return;
              setState(() {
                dateTimeRange = DateTimeRange(
                  start: dateTimeRange.start,
                  end: dateTime,
                );
                widget.event.dateTimeRange = dateTimeRange;
              });
            },
          ),
        ),
        Row(
          children: [
            DropdownMenu<Color>(
              label: const Text('Color'),
              initialSelection: widget.event.eventData?.color ?? Colors.blue,
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: Colors.blue, label: 'blue'),
                DropdownMenuEntry(value: Colors.green, label: 'green'),
                DropdownMenuEntry(value: Colors.red, label: 'red'),
              ],
              onSelected: (value) {
                if (value == null) return;
                widget.event.eventData =
                    widget.event.eventData?.copyWith(color: value);
              },
            )
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(widget.event);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            ),
          ],
        )
      ],
    );
  }
}
