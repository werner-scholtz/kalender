import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';

class CalendarViewV2<T extends Object?> extends StatefulWidget {
  const CalendarViewV2.singleDay({
    super.key,
    required this.controller,
    required this.components,
    required this.timelineWidth,
  }) : viewType = ViewType.singleDay;

  const CalendarViewV2.multiDay({
    super.key,
    required this.controller,
    required this.components,
    required this.timelineWidth,
  }) : viewType = ViewType.multiDay;

  const CalendarViewV2.month({
    super.key,
    required this.controller,
    required this.components,
  })  : viewType = ViewType.month,
        timelineWidth = null;

  const CalendarViewV2.schedule({
    super.key,
    required this.controller,
    required this.components,
  })  : viewType = ViewType.schedule,
        timelineWidth = null;

  final CalendarController<T> controller;
  final CalendarComponents<T> components;

  final ViewType viewType;
  final double? timelineWidth;

  @override
  State<CalendarViewV2<T>> createState() => _CalendarViewV2State<T>();
}

class _CalendarViewV2State<T extends Object?> extends State<CalendarViewV2<T>> {
  @override
  Widget build(BuildContext context) {
    switch (widget.viewType) {
      case ViewType.singleDay:
        return Container();
      case ViewType.multiDay:
        return Container();
      case ViewType.month:
        return Container();
      case ViewType.schedule:
        return Container();
    }
  }
}
