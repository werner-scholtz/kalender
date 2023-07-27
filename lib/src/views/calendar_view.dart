import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_controller.dart';

class CalendarView<T extends Object?> extends StatefulWidget {
  const CalendarView({
    super.key,
    this.controller,
  });

  /// The [CalendarController] used by the [CalendarView].
  final CalendarController<T>? controller;

  @override
  State<CalendarView<T>> createState() => _CalendarViewState<T>();
}

class _CalendarViewState<T extends Object?> extends State<CalendarView<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
