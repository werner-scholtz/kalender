import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar/calendar_controller.dart';
import 'package:kalender/src/models/view_configurations/schedule_configurations/schedule_view_configuration.dart';

class ScheduleContent<T> extends StatelessWidget {
  const ScheduleContent({
    super.key,
    required this.controller,
    required this.viewConfiguration,
  });

  final CalendarController<T> controller;
  final ScheduleViewConfiguration viewConfiguration;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
