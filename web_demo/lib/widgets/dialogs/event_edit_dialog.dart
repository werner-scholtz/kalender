import 'package:web_demo/models/event.dart';
import 'package:web_demo/widgets/dialogs/date_time_range_editor.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class EventEditDialog extends StatelessWidget {
  const EventEditDialog({
    super.key,
    required this.dialogTitle,
    required this.event,
    required this.deleteEvent,
    required this.cancelEdit,
  });

  final String dialogTitle;
  final CalendarEvent<Event> event;
  final void Function(CalendarEvent<Event> event) deleteEvent;
  final VoidCallback cancelEdit;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dialogTitle),
          IconButton.filledTonal(
            tooltip: 'Delete Event',
            onPressed: () {
              deleteEvent(event);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      children: [
        TextFormField(
          initialValue: event.eventData?.title,
          decoration: const InputDecoration(
            labelText: 'Title',
            isDense: true,
          ),
          onChanged: (value) {
            event.eventData?.title = value;
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: DateTimeRangeEditor(
            dateTimeRange: event.dateTimeRange,
            onStartChanged: (dateTime) {
              if (dateTime.isAfter(event.dateTimeRange.end)) return;
              event.dateTimeRange = DateTimeRange(
                start: dateTime,
                end: event.dateTimeRange.end,
              );
            },
            onEndChanged: (dateTime) {
              if (dateTime.isBefore(event.dateTimeRange.start)) return;
              event.dateTimeRange = DateTimeRange(
                start: event.dateTimeRange.start,
                end: dateTime,
              );
            },
          ),
        ),
        Row(
          children: [
            DropdownMenu<Color>(
              label: const Text('Color'),
              initialSelection: event.eventData?.color ?? Colors.blue,
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: Colors.blue, label: 'blue'),
                DropdownMenuEntry(value: Colors.green, label: 'green'),
                DropdownMenuEntry(value: Colors.red, label: 'red'),
              ],
              onSelected: (value) {
                if (value == null) return;
                event.eventData?.color = value;
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
                cancelEdit();
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop(true);
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
