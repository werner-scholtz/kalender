import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_controller.dart';

class SingleDayView<T extends Object?> extends StatefulWidget {
  const SingleDayView({
    super.key,
    required this.controller,
  });

  final CalendarController<T> controller;

  @override
  State<SingleDayView<T>> createState() => _SingleDayViewState<T>();
}

class _SingleDayViewState<T extends Object?> extends State<SingleDayView<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
