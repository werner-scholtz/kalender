import 'package:example/extentions.dart';
import 'package:example/models/event.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class EventEditSheet extends StatelessWidget {
  const EventEditSheet({
    super.key,
    required this.event,
  });
  final CalendarEvent<Event> event;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: event,
        builder: (context, child) {
          return SizedBox(
            width: double.infinity,
            height: 180,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: event.eventData?.title,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                              isDense: true,
                            ),
                            onChanged: (value) {
                              event.eventData?.title = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.play_arrow),
                        ),
                        FilledButton.tonal(
                          child: Text(
                            '${event.start.year}-${event.start.month}-${event.start.day}',
                          ),
                          onPressed: () async {
                            DateTime? newStart = await showDatePicker(
                              context: context,
                              initialDate: event.start,
                              firstDate: DateTime(1970),
                              lastDate: event.end,
                            );
                            if (newStart == null) return;
                            event.start = newStart;
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton.tonal(
                                child: Text(
                                  event.start.hoursMinutes,
                                ),
                                onPressed: () async {
                                  TimeOfDay? timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(event.start),
                                  );
                                  if (timeOfDay == null) return;
                                  DateTime newStart = event.start.copyWith(
                                    hour: timeOfDay.hour,
                                    minute: timeOfDay.minute,
                                  );
                                  if (newStart.isAfter(event.end)) return;

                                  event.start = newStart;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.stop),
                        ),
                        FilledButton.tonal(
                          child: Text(
                            '${event.end.year}-${event.end.month}-${event.end.day}',
                          ),
                          onPressed: () async {
                            DateTime? newEnd = await showDatePicker(
                              context: context,
                              initialDate: event.end,
                              firstDate: event.start,
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (newEnd == null) return;
                            event.end = newEnd;
                          },
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton.tonal(
                                child: Text(
                                  event.end.hoursMinutes,
                                ),
                                onPressed: () async {
                                  TimeOfDay? timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime:
                                        TimeOfDay.fromDateTime(event.end),
                                  );
                                  if (timeOfDay == null) return;
                                  DateTime newEnd = event.end.copyWith(
                                    hour: timeOfDay.hour,
                                    minute: timeOfDay.minute,
                                  );
                                  if (newEnd.isBefore(event.end)) return;
                                  event.start = newEnd;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
