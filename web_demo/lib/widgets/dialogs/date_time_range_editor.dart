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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DateTimePicker(
            title: 'From',
            helpText: 'Select start date',
            dateTime: dateTimeRange.start,
            onDateTimeChanged: onStartChanged,
            maxDateTime: dateTimeRange.end,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DateTimePicker(
            title: 'To',
            helpText: 'Select end date',
            dateTime: dateTimeRange.end,
            onDateTimeChanged: onEndChanged,
            minDateTime: dateTimeRange.start,
          ),
        ),
      ],
    );
  }
}

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    super.key,
    required this.title,
    required this.dateTime,
    required this.onDateTimeChanged,
    this.helpText,
    this.minDateTime,
    this.maxDateTime,
  });

  final String title;
  final String? helpText;
  final DateTime dateTime;
  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final Function(DateTime dateTime) onDateTimeChanged;

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime dateTime = widget.dateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Form(
          autovalidateMode: AutovalidateMode.always,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: dateTime.hour.toString(),
                  onChanged: (value) {
                    int? hourValue = int.tryParse(value);
                    if (hourValue == null || hourValue < 0 || hourValue > 23) {
                      return;
                    }

                    widget.onDateTimeChanged(
                      DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        hourValue,
                        dateTime.minute,
                      ),
                    );
                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    int hourValue = int.parse(value);

                    DateTime newDateTime = DateTime(
                      dateTime.year,
                      dateTime.month,
                      dateTime.day,
                      hourValue,
                      dateTime.minute,
                    );

                    if (widget.minDateTime != null &&
                        newDateTime.isBefore(widget.minDateTime!)) {
                      return 'Invalid';
                    }

                    if (widget.maxDateTime != null &&
                        newDateTime.isAfter(widget.maxDateTime!)) {
                      return 'Invalid';
                    }

                    dateTime = newDateTime;

                    return null;
                  },
                  decoration: const InputDecoration(isDense: true),
                ),
              ),
              const Text(':'),
              Expanded(
                flex: 1,
                child: TextFormField(
                  initialValue: widget.dateTime.minute.toString(),
                  onChanged: (value) {
                    int? minuteValue = int.tryParse(value);
                    if (minuteValue == null ||
                        minuteValue < 0 ||
                        minuteValue > 59) return;
                    widget.onDateTimeChanged(
                      DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        dateTime.hour,
                        minuteValue,
                      ),
                    );
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    int? minuteValue = int.parse(value);

                    DateTime newDateTime = DateTime(
                      dateTime.year,
                      dateTime.month,
                      dateTime.day,
                      dateTime.hour,
                      minuteValue,
                    );

                    if (widget.minDateTime != null &&
                        newDateTime.isBefore(widget.minDateTime!)) {
                      return 'Invalid';
                    }

                    if (widget.maxDateTime != null &&
                        newDateTime.isAfter(widget.maxDateTime!)) {
                      return 'Invalid';
                    }

                    dateTime = newDateTime;

                    return null;
                  },
                  decoration: const InputDecoration(isDense: true),
                ),
              ),
              Flexible(
                flex: 2,
                child: TextButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.dateTime,
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2070),
                      helpText: widget.helpText,
                    );
                    if (selectedDate == null) return;
                    widget.onDateTimeChanged(selectedDate);
                  },
                  child: Text(
                      '${widget.dateTime.day}/${widget.dateTime.month}/${widget.dateTime.year}'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
