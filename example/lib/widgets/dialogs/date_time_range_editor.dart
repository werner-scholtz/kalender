import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateTimeRangeEditor extends StatelessWidget {
  const DateTimeRangeEditor({
    super.key,
    required this.dateTimeRange,
    required this.onStartChanged,
    required this.onEndChanged,
  });
  final DateTimeRange dateTimeRange;
  final void Function(DateTime) onStartChanged;
  final void Function(DateTime) onEndChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateTimePicker(
          title: 'From',
          helpText: 'Select start date',
          dateTime: dateTimeRange.start,
          onDateTimeChanged: onStartChanged,
        ),
        DateTimePicker(
          title: 'To',
          helpText: 'Select end date',
          dateTime: dateTimeRange.end,
          onDateTimeChanged: onEndChanged,
        ),
      ],
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    super.key,
    required this.title,
    required this.dateTime,
    required this.onDateTimeChanged,
    this.helpText,
  });
  final String title;
  final String? helpText;
  final DateTime dateTime;
  final Function(DateTime dateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            Flexible(
              flex: 2,
              child: TextButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: dateTime,
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2070),
                    helpText: helpText,
                  );
                  if (selectedDate == null) return;
                  onDateTimeChanged(selectedDate);
                },
                child: Text('${dateTime.day}/${dateTime.month}/${dateTime.year}'),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: dateTime.hour.toString(),
                onFieldSubmitted: (value) {
                  int? hourValue = int.tryParse(value);
                  if (hourValue == null || hourValue < 0 || hourValue > 23) return;
                  onDateTimeChanged(DateTime(dateTime.year, dateTime.month, dateTime.day, hourValue, dateTime.minute));
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                decoration: const InputDecoration(isDense: true),
              ),
            ),
            const Text(':'),
            Expanded(
              flex: 1,
              child: TextFormField(
                initialValue: dateTime.minute.toString(),
                onFieldSubmitted: (value) {
                  int? minuteValue = int.tryParse(value);
                  if (minuteValue == null || minuteValue < 0 || minuteValue > 59) return;
                  onDateTimeChanged(DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, minuteValue));
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
                decoration: const InputDecoration(isDense: true),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
