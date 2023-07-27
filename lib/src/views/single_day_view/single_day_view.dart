import 'package:flutter/material.dart';
import 'package:kalender/src/models/calendar_components.dart';
import 'package:kalender/src/models/calendar_configuration.dart';
import 'package:kalender/src/models/calendar_controller.dart';
import 'package:kalender/src/models/calendar_functions.dart';
import 'package:kalender/src/models/calendar_style.dart';
import 'package:kalender/src/models/view_configurations/view_configuration.dart';
import 'package:kalender/src/models/view_functions.dart';
import 'package:kalender/src/providers/calendar_internals.dart';

class SingleDayView<T extends Object?> extends StatefulWidget {
  const SingleDayView({
    super.key,
    required this.controller,
    required this.viewConfiguration,
    this.initialDate,
    this.dateTimeRange,
  });

  final CalendarController<T> controller;
  final SingleDayViewConfiguration viewConfiguration;
  final DateTime? initialDate;
  final DateTimeRange? dateTimeRange;

  @override
  State<SingleDayView<T>> createState() => _SingleDayViewState<T>();
}

class _SingleDayViewState<T extends Object?> extends State<SingleDayView<T>> with ViewFunctions {
  CalendarController<T>? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != widget.controller) {
      _controller = widget.controller;
    }
  }

  @override
  void didUpdateWidget(covariant SingleDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != widget.controller) {
      _controller = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CalendarInternals<T>(
      components: CalendarComponents<T>(),
      configuration: CalendarConfiguration(),
      functions: CalendarFunctions<T>(),
      style: const CalendarStyle(),
      child: Container(),
    );
  }
}
